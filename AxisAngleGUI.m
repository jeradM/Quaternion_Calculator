function AxisAngleGUI( Q, quatStr )
%AxisAngleGUI shows angle-axis representation of quaternion rotation
%
% Q is the rotation quaternion, quatStr is the unit vector string
% representation of the quaternion. This function is only meant to be
% called from QuatGUI.
%

    aaWidth = 15;
    aaHeight = 17;

    % Create Main Window
    aaFig = figure;
    set(aaFig,...
        'Units', 'centimeters',...
        'Position', [5 2 aaWidth aaHeight],...
        'Visible', 'on',...
        'WindowStyle', 'modal' ,...
        'Resize', 'off' ...
        );
    
    % Title
    aaTitle = uicontrol;
    set(aaTitle,...
        'Parent', aaFig,...
        'Units', 'centimeters',...
        'Position', [0 aaHeight-1.5 aaWidth 1],...
        'Style', 'Text',...
        'String', 'Axis-Angle Representation',...
        'FontSize', 18 ...
        );
    
    % Hidden Axes for quaternion text object
    aaAxes = axes;
    set(aaAxes,...
        'Parent', aaFig,...
        'Units', 'centimeters',...
        'Position', [0 13 aaWidth 2] ,...
        'XLim', [0 aaWidth],...
        'YLim', [0 2],...
        'Visible', 'off' ...
        );
    
    % Textbox for axis and angle
    aaTextBox = annotation('textbox',... 
        'Units', 'centimeters',...
        'Position', [.2 5 aaWidth-.4 8],...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'middle',...
        'LineStyle', 'none' ,...
        'FontSize', 24,...
        'String', ' ',...
        'Interpreter', 'latex' ...
        );
    
    % Button to view animated axis-angle rotation
    plotAAButton = uicontrol;
    set(plotAAButton,...
        'Parent', aaFig,...
        'Units', 'centimeters',...
        'Position', [aaWidth/2-2 2 4 1.2], ...
        'String', 'View Rotation', ...
        'FontSize', 14 ,...
        'Callback', @animateAA_Callback ...
        );
    
    % Checkbox to add object to animation
    objectCheckbox = uicontrol;
    set(objectCheckbox,...
        'Parent', aaFig,...
        'Units', 'centimeters',...
        'Style', 'checkbox',...
        'Position', [aaWidth/2-1.5 1 4 .7] ,...
        'String', 'Add Object' ,...
        'Value', 0 ,...
        'FontSize', 12 ...
        );
    
    % Quaternion description
    axes(aaAxes);
    t = text(2, 1, quatStr, 'FontSize', 20, 'Interpreter', 'latex');
    
    % Axis-angle text
    [a x y z] = Q.toAxisAngle();

    astr = sprintf('$ \\theta = %.2f ^\\circ $', a);
    xstr = sprintf('$ x = %.2f $', x);
    ystr = sprintf('$ y = %.2f $', y);
    zstr = sprintf('$ z = %.2f $', z);
    s = {astr, ' ', xstr, ystr, zstr};
    set(aaTextBox, 'String', s);
    
    function animateAA_Callback(source, ~)
        % Create figure window for animation
        aaAnimFig = figure(11);
        set(aaAnimFig,... 
            'Units', 'centimeters',... 
            'Position', [4 2 20 20] ,...
            'WindowStyle', 'modal' ...
        );
        
        % Get object checkbox value
        obval = get(objectCheckbox, 'Value');
        
        if obval 
            ob = true;
        else
            ob = false;
        end
        
        % Get orthogonal 3-dimensional axis set and position in fig window
        aset = GetAxisSet(11, ob);
        set(gca, 'Position', [-.3 -.3 1.6 1.6]);
        
        % Plot rotation axis
        hold on
        plot3([-10*x 10*x], [-10*y 10*y], [-10*z 10*z], '--k', 'LineWidth', .75);
        rotate3d on;
        light('Position', [1 0 1], 'Style', 'local');
        light('Position', [-1 0 1], 'Style', 'local');
        light('Position', [0 0 -1], 'Style', 'local');
        lighting gouraud;
        
        % Wait 2 seconds
        pause(2);
        
        % Plot original axes
        col = ['r','b','g'];
        for j=1:2:6
            if ishandle(aaAnimFig)
                adata = get(aset(j),{'Xdata','Ydata','Zdata'});
                plot3(mean(adata{1},2),mean(adata{2},2),mean(adata{3},2),[col((j+1)/2),'-'],'LineWidth',1.4);
            end
        end
        
        % Animate rotation of axis set until figure closed
        while ishandle(aaAnimFig)
            % Run rotation forward if figure still open
            for j = 1:75
               if ishandle(aaAnimFig), 
                   rotate(aset, [x y z], a/75, [0 0 0]);
                   pause(.02);
               end
            end
            pause(2);
            for j = 1:75
               % Run rotation backward if figure still open
               if ishandle(aaAnimFig), 
                   rotate(aset, [x y z], -a/75, [0 0 0]);
                   pause(.02);
               end
            end
            pause(2);
        end
    end

end
