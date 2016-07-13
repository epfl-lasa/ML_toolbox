%A demo of how Adaboost works.
%
%Some base learners have external dependancies. CART requires the stats
%toolbox (classregtree). RBF SVM requires libsvm (which must be above
%bioinformatics toolbox in the path). NeuralNetwork requires netlab.
%
%The demo displays some 2-D data, and shows the development of the decision
%boundary, margins, error rate and margin distribution as a boosted
%ensemble is trained.
%
%The data is split into two classes - red and blue. The decision boundary
%appears as a yellow contour. The margins are shown on a white->black
%gradient, where white is a confident classification as blue and black is a
%confident classification as red.
%
%To add a single learner, use the "Add Learner" button, or "Add 10" to add
%10 learners. Learners are shown in a scrollable list,
%with their adjusted weights beside them. Weight adjustment involves
%normalisation and then scaling so that 1 represents an average learner
%weight. These weights can be adjusted (even made negative), and learners
%can be enabled or disabled individual using the check box. Right-clicking
%on the checkbox disables all other learners. The 'Reset' button enables
%all learners and sets their weights to those computed by Adaboost.
%
%The 'Plot Error' and 'Plot Margins' buttons open new windows to display
%addition information. 'Plot Error' shows the training error (blue) and the
%generalisation error (red) against the size of the ensemble. 'Plot
%Margins' shows the cdf of the margins for the current ensemble. The height
%of the line above 0 indicates the proportion of the data with that margin
%or below.
%
%The two drop-down menus at the top allow a choice of base learner
%algorithms and data generating functions. When either of these are
%changed, the ensemble is completely reset for the new learner type or data
%set.
classdef boosting_demo < handle
  
  properties (Constant=true)
    
    %Starting size of the ensemble
    initial_size = 1;
    %Resolution of the decision boundaries and margins. Large numbers make
    %it slower.
    resolution = 200;
    
  end
  
  properties
    
    fig;
    plot_area;
    learner_labels;
    learner_check;
    learner_weights;
    weight_labels;
    learner_count;
    learner_enabled;
    pretend_weights;
    adaboost;
    inputs;
    outputs;
    g_inputs;
    example_weights;
    g_outputs;
    bgc = [0.8 0.8 0.8];
    data_handle;
    data_colors;
    margin_handle;
    boundary_handle;
    margins;
    predictions;
    x_grid;
    y_grid;
    add_learner_button;
    add_10_button;
    enable_all_button;
    error_rate_button;
    error_fig;
    plotting_error;
    margin_distribution_button;
    margin_fig;
    plotting_margin;
    learner_scroll;
    first_learner = 1;
    base_learner;
    base_learners;
    base_learner_names;
    base_learner_popup;
    data_func;
    data_funcs;
    data_func_names;
    data_func_popup;
    data_points;
    running = true;
    
  end
  
  methods
    
    function a = boosting_demo()
      
      %Number of data points to generate
      a.data_points = 200;
      %To add a new base learner, add the construction function to this
      %list, then add the name to a.base_learner_names. The base learner
      %must have train(inputs, outputs) and outputs = test(inputs)
      %functions.
      base_learner_num = 6;
      a.base_learners = {@()SVM() @()LinearRegression @()CART() @()OnlineNaiveBayes(0) @()NeuralNetwork(10, 0.01, 2, 'linear', 50), @()Stump()};
      a.base_learner_names = {'RBF SVM', 'Linear Regression', 'CART', 'Naive Bayes', 'Neural Network', 'Decision Stump'};
      a.base_learner = a.base_learners{base_learner_num};
      %To add a new data generator, add the function to this list, where c
      %is the number of data points to generate. The function must return
      %[inputs outputs] where inputs is cX2 and outputs is cX1. Then add
      %the name to the second list.
      data_func_num = 3;
      a.data_funcs = {@(c)DataGen.circle(c, 5, 0.5), @(c)DataGen.checkerboard(c, 10, 2, rand * pi), ...
        @(c)DataGen.gaussians(c, [-2 -2], [2 2], [2 2], [2 2])};
      a.data_func_names = {'Circle', 'Checkerboard', 'Gaussians'};
      a.data_func = a.data_funcs{data_func_num};
      
      %Make the ensemble
      a.adaboost = Adaboost(boosting_demo.initial_size, a.base_learner);
      %Sort out the main window
      screen_size = get(0, 'ScreenSize');
      a.fig = figure('Position', [(screen_size(3) - 800) / 2 (screen_size(4) - 600) / 2 800 600], 'MenuBar', 'none', ...
        'CloseRequestFcn', @(varargin)a.halt(), 'Name', 'Boosting Demo', 'NumberTitle', 'off');

      %Create the error and margin graphs.
      a.error_fig = figure('Name', 'Error Rates', 'NumberTitle', 'off');
      a.margin_fig = figure('Name', 'Margin Distribution', 'NumberTitle', 'off');
      set(a.error_fig, 'visible', 'off');
      set(a.margin_fig, 'visible', 'off');
      figure(a.fig);
      a.plot_area = axes('Units','Pixels');
      
      hold on;
      
      colormap('gray');
      %Plot the data
      a.data_handle = scatter([], [], [], '+', 'SizeDataSource', 'a.example_weights', 'XDataSource', 'a.inputs(:, 1)',...
        'YDataSource', 'a.inputs(:, 2)', 'CDataSource', 'a.data_colors', 'HitTest', 'off',...
        'LineWidth', 3);
      
      %Plot the margin and boundary contours
      min = -5;
      max = 5;
      step = (max - min) / boosting_demo.resolution;
      range = min:step:max;
      [a.x_grid a.y_grid] = meshgrid(range, range);
      a.margins = repmat(range, size(a.x_grid, 2), 1);
      [null a.margin_handle] = contourf(a.x_grid, a.y_grid, a.margins, 'XDataSource', 'a.x_grid', ...
        'YDataSource', 'a.y_grid', 'ZDataSource', 'a.margins', 'LineStyle', 'none');
      [null a.boundary_handle] = contour(a.x_grid, a.y_grid, a.margins > 0, 1, 'y', 'XDataSource', 'a.x_grid', ...
        'YDataSource', 'a.y_grid', 'ZDataSource', 'a.margins > 0', 'LineWidth', 2);      
      
      hold off;
      
      %Make GUI components
      a.base_learner_popup = uicontrol('Style', 'popupmenu', 'String', a.base_learner_names, ...
        'Callback', @(varargin)a.base_learner_change(), 'Value', base_learner_num);
      a.data_func_popup = uicontrol('Style', 'popupmenu', 'String', a.data_func_names, ...
        'Callback', @(varargin)a.data_func_change(), 'Value', data_func_num);
      a.add_learner_button = uicontrol('String', 'Add Learner', 'Callback', @(varargin)a.add_learner());
      a.add_10_button = uicontrol('String', 'Add 10', 'Callback', @(varargin)a.add_10());
      a.enable_all_button = uicontrol('String', 'Reset', 'Callback', @(varargin)a.enable_all());
      a.error_rate_button = uicontrol('String', 'Plot Error', 'Callback', @(varargin)a.plot_error());
      a.margin_distribution_button = uicontrol('String', 'Plot Margins', ...
        'Callback', @(varargin)a.plot_margins());      
      a.learner_scroll = uicontrol('Style', 'Slider', 'min', 0, 'max', 1);
     
      
     % listener = handle.listener(a.learner_scroll,'ActionEvent',@(varargin)a.scroll_learners());
      listener = addlistener(a.learner_scroll,'Action',@(varargin)a.scroll_learners());

      
      setappdata(a.learner_scroll, 'listener', listener);    
      
      %Generate the data
      a.random_data();
      %Train the ensemble (First learner)
      a.train_adaboost();
      %Layout function
      set(a.fig, 'ResizeFcn', @(varargin)a.do_layout());
      
    end
    
    %Stop the program, called when the window is closed
    function halt(a)
      a.running = false;
      if (ishandle(a.error_fig))
        close(a.error_fig);
      end
      if (ishandle(a.margin_fig))
        close(a.margin_fig);
      end
      delete(a.fig);
    end
    
    function do_layout(a)
      %Layout. Do the side bar, and make the data take up the rest of the
      %window
      try
        figure(a.fig);
        pos = get(a.fig, 'Position');
        fig_width = pos(3) - 370;
        fig_height = pos(4) - 60;
        fig_size = min(fig_width, fig_height);
        set(a.plot_area, 'Position', [350 (pos(4) - fig_size - 30) fig_size fig_size]);
        top = pos(4) - 40;
        set(a.base_learner_popup, 'Position', [10 top 150 20]);
        set(a.data_func_popup, 'Position', [170 top 150 20]);
        top = top - 30;
        set(a.error_rate_button, 'Position', [10 top 100 20]);
        set(a.margin_distribution_button, 'Position', [110 top 100 20]);
        set(a.add_10_button, 'Position', [210 top 100 20]);
        top = top - 30;
        set(a.add_learner_button, 'Position', [10 top 150 20]);
        set(a.enable_all_button, 'Position', [170 top 130 20]);
        top = top - 30;
        set(a.learner_scroll, 'Position', [310 20 20 top]);
        %Create new base learner components as necessary
        for i=1:a.adaboost.k_max
          if i > numel(a.learner_labels)
            a.learner_labels(i) = uicontrol('Style','text','String',['Learner ' num2str(i)], ...
              'BackgroundColor',a.bgc,'HorizontalAlignment','left', 'FontSize', 14,...
              'FontWeight', 'bold');
            a.learner_check(i) = uicontrol('Style', 'Checkbox', 'ButtonDownFcn', ...
              @(varargin)a.individual_learner(i), 'Callback', @(varargin)a.enable_learner(i));
            a.learner_weights(i) = uicontrol('Style','Slider','Min',-1,'Max',1);
            a.weight_labels(i) = uicontrol('Style','text','String','0',...
              'FontSize', 14, 'FontWeight', 'bold');            
            listener = handle.listener(a.learner_weights(i),'ActionEvent',@(varargin)a.set_weight(i));
            setappdata(a.learner_weights(i), 'listener', listener);
          end
        end
        for i=1:a.first_learner-1
            set(a.learner_labels(i), 'Visible', 'off');
            set(a.learner_check(i), 'Visible', 'off');
            set(a.learner_weights(i), 'Visible', 'off');
            set(a.weight_labels(i), 'Visible', 'off');
        end
        for i=a.first_learner:a.adaboost.k_max
          if (top > 20)
            set(a.learner_labels(i), 'Visible', 'on');
            set(a.learner_check(i), 'Visible', 'on');
            set(a.learner_weights(i), 'Visible', 'on');
            set(a.weight_labels(i), 'Visible', 'on');            
            set(a.learner_labels(i), 'Position',[10 top 110 20]); 
            set(a.learner_check(i), 'Position',[120 top 20 20]);
            set(a.learner_weights(i), 'Position',[150 top 100 20]);
            set(a.weight_labels(i), 'Position',[260 top 40 20]);
          else
            set(a.learner_labels(i), 'Visible', 'off');
            set(a.learner_check(i), 'Visible', 'off');
            set(a.learner_weights(i), 'Visible', 'off');
            set(a.weight_labels(i), 'Visible', 'off');
          end
          top = top - 30;
        end
      catch exception
        %Buh
      end
      
    end
    
    %Called when the base learner type is changed. Reset the ensemble.
    function base_learner_change(a)
      learner_num = get(a.base_learner_popup, 'Value');
      a.base_learner = a.base_learners{learner_num};
      a.new_ensemble();
    end
    
    %Called when the data generating function is changed. Reset the
    %ensemble and generate new data.
    function data_func_change(a)
      data_num = get(a.data_func_popup, 'Value');
      a.data_func = a.data_funcs{data_num};
      a.random_data();
      a.new_ensemble();
    end
    
    %Create a new ensemble, and delete any lingering rubbish.
    function new_ensemble(a)
      for i=2:a.learner_count
        delete(a.learner_labels(i));
        delete(a.learner_check(i));
        delete(a.learner_weights(i));
        delete(a.weight_labels(i));
      end
      a.learner_labels = a.learner_labels(1);
      a.learner_check = a.learner_check(1);
      a.learner_weights = a.learner_weights(1);
      a.weight_labels = a.weight_labels(1);
      a.adaboost = Adaboost(boosting_demo.initial_size, a.base_learner);
      a.learner_count = 1;
      a.first_learner = 1;
      set(a.learner_scroll, 'max', 1);
      set(a.learner_scroll, 'Value', 0);
      a.adaboost.k_max = a.learner_count;
      a.adaboost.k_next = a.learner_count;
      a.learner_enabled = true;
      a.train_adaboost();
    end
    
    %When the learner scrollbar moves.
    function scroll_learners(a)

      a.first_learner = max(ceil(a.learner_count - get(a.learner_scroll, 'Value')), 1);
      a.do_layout();
      
    end
    
    %Plot an error against ensemble size graph in a separate window.
    function plot_error(a)
      
      preds = cell2mat(arrayfun(@(x)a.adaboost.learners{x}.test(a.inputs) .* a.outputs, ...
        1:a.learner_count, 'UniformOutput', 0));
      weighted_preds = preds .* repmat(a.pretend_weights .* a.learner_enabled, numel(a.outputs), 1);
      cumulative_margins = cumsum(weighted_preds, 2);
      g_preds = cell2mat(arrayfun(@(x)a.adaboost.learners{x}.test(a.g_inputs) .* a.g_outputs, ...
        1:a.learner_count, 'UniformOutput', 0));
      g_weighted_preds = g_preds .* repmat(a.pretend_weights .* a.learner_enabled, numel(a.g_outputs), 1);
      g_cumulative_margins = cumsum(g_weighted_preds, 2);      
      figure(a.error_fig);
      set(a.error_fig, 'Name', 'Error Rates', 'NumberTitle', 'off');
      clf;
      hold on;
      plot(1:a.learner_count, mean(cumulative_margins < 0), 'LineWidth', 2);
      plot(1:a.learner_count, mean(g_cumulative_margins < 0), 'r', 'LineWidth', 2);
      hold off;
      a.plotting_error = true;
      
    end
    
    %Plot the margin distribution in a separate window.
    function plot_margins(a)
      
      preds = cell2mat(arrayfun(@(x)a.adaboost.learners{x}.test(a.inputs) .* a.outputs, ...
        1:a.learner_count, 'UniformOutput', 0));
      weighted_preds = preds .* repmat(a.pretend_weights .* a.learner_enabled, numel(a.outputs), 1);
      final_margins = sum(weighted_preds, 2);
      range = -1:0.01:1;
      figure(a.margin_fig);
      set(a.margin_fig, 'Name', 'Margin Distribution', 'NumberTitle', 'off');
      clf;
      plot(range, mean(repmat(final_margins, 1, numel(range)) < repmat(range, numel(final_margins), 1)))
      a.plotting_margin = true;
      
    end
    
    %Add 10 learners.
    function add_10(a)
      
      try
        i = 0;
        while (i < 10 && a.running)
          a.add_learner();
          i = i + 1;
        end
      catch
      end
      
    end
    
    %Add one learner.
    function add_learner(a)
      
      a.learner_count = a.learner_count + 1;
      set(a.learner_scroll, 'max', a.learner_count);
      set(a.learner_scroll, 'Value', a.learner_count - a.first_learner);
      a.adaboost.k_max = a.learner_count;
      a.adaboost.k_next = a.learner_count;
      a.learner_enabled(a.learner_count) = true;
      a.adaboost.train(a.inputs, a.outputs);
      a.pretend_weights = a.adaboost.learner_weights;
      new_predictions = a.adaboost.learners{a.learner_count}.test([a.x_grid(:) a.y_grid(:)]);
      a.predictions = [a.predictions new_predictions];
      a.example_weights = abs(a.adaboost.d_weights) * a.data_points * 25;
      a.do_layout();
      a.refresh_weights();
      a.refresh_enabled();
      a.redraw();
      
    end
    
    %Train the first learner in Adaboost.
    function train_adaboost(a)
    
       a.adaboost.train(a.inputs, a.outputs);
       a.learner_count = a.adaboost.k_max;
       a.learner_enabled = ones(1, a.learner_count);
       a.pretend_weights = a.adaboost.learner_weights';
       a.predictions = cell2mat(arrayfun(@(x)a.adaboost.learners{x}.test([a.x_grid(:) a.y_grid(:)]), ...
        1:a.learner_count, 'UniformOutput', 0));
       a.do_layout();       
       a.refresh_weights();
       a.refresh_enabled();
       a.redraw();
      
    end
    
    %Set the weights back to Adaboost weights.
    function reset_weights(a)
      a.pretend_weights = a.adaboost.learner_weights;
      a.refresh_weights();
    end
    
    %Enable a base learner
    function enable_learner(a, i)
      a.learner_enabled(i) = ~a.learner_enabled(i);
      set(a.learner_check(i), 'Value', a.learner_enabled(i));
      a.redraw();
    end
    
    %Enable all base learners.
    function enable_all(a)
      for j=1:a.learner_count
        a.learner_enabled(j) = true;
        set(a.learner_check(j), 'Value', true);        
      end
      a.reset_weights();
      a.redraw();
    end
    
    %Show one single base learner.
    function individual_learner(a, i)
      
      if strcmp(get(gcf,'SelectionType'), 'normal')
        a.enable_learner(i);
      else
        for j=1:a.learner_count
          if (j ~= i)
            a.learner_enabled(j) = false;
            set(a.learner_check(j), 'Value', false);
          else
            a.learner_enabled(j) = true;
            set(a.learner_check(j), 'Value', true);
          end
        end
        a.redraw();
      end
    end
    
    %Change the weight of a base learner.
    function set_weight(a, i)
      a.pretend_weights(i) = get(a.learner_weights(i), 'Value');
      a.refresh_weights();
      a.redraw();
    end
    
    %Redraw the data
    function redraw(a)
      
      try
        a.margins = reshape(a.predictions * (a.pretend_weights .* a.learner_enabled)', ...
          size(a.x_grid, 1), size(a.x_grid, 2));
        a.margins = a.margins ./ max(abs(a.margins(:)));

        refreshdata(a.margin_handle, 'caller');
        refreshdata(a.boundary_handle, 'caller');
        refreshdata(a.data_handle, 'caller');      
        drawnow;
        if (a.plotting_error)
          a.plot_error();
        end
        if (a.plotting_margin)
          a.plot_margins();
        end
      catch
      end
      
    end
    
    %Update the base learner weights (normalise etc.)
    function refresh_weights(a)
      a.pretend_weights = a.pretend_weights / sum(abs(a.pretend_weights));
      for i=1:a.learner_count
        set(a.learner_weights(i), 'Value', a.pretend_weights(i));
        set(a.weight_labels(i), 'String', floor(a.data_points * a.pretend_weights(i) * sum(a.learner_enabled)) / a.data_points);   
      end
    end
    
    %Update the checkboxes to show if learners are enabled.
    function refresh_enabled(a)
      for i=1:a.learner_count
        set(a.learner_check(i), 'Value', a.learner_enabled(i));
      end
    end
    
    %Generate some data from the required function.
    function random_data(a)
      
      [a.inputs a.outputs] = a.data_func(a.data_points);
      [a.g_inputs a.g_outputs] = a.data_func(a.data_points.*2);    
      a.data_colors = [a.outputs == -1 zeros(a.data_points, 1) a.outputs == 1];
      a.example_weights = ones(a.data_points, 1) * a.data_points;
      
    end
    
  end
  
end

