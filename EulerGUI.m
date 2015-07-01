function EulerGUI( Q, quatStr )
% EulerGUI shows ZYX euler (Tait-Bryan) representation of a rotation
% quaternion
%
% Q is the rotation quaternion, quatStr is the unit vector string
% representation of the quaternion. This function is only meant to be
% called from QuatGUI.
%
    eWidth = 15;
    eHeight = 17;

    % Create Main Euler Window
    eFig = figure;
    set(eFig,...
        'Units', 'centimeters',...
        'Position', [5 2 eWidth eHeight],...
        'Visible', 'on',...
        'WindowStyle', 'modal' ,...
        'Resize', 'off' ...
        );
    
    % Title
    eTitle = uicontrol;
    set(eTitle,...
        'Parent', eFig,...
        'Units', 'centimeters',...
        'Position', [0 eHeight-1.5 eWidth 1],...
        'Style', 'Text',...
        'String', 'ZYX Euler (Tait-Bryan) Angles',...
        'FontSize', 18 ...
        );
    
    % Hidden Axes for quaternion text object
    eAxes = axes;
    set(eAxes,...
        'Parent', eFig,...
        'Units', 'centimeters',...
        'Position', [0 13 eWidth 2] ,...
        'XLim', [0 eWidth],...
        'YLim', [0 2],...
        'Visible', 'off' ...
        );
    
    % Textbox for euler angles
    eulerTextBox = annotation('textbox',... 
        'Units', 'centimeters',...
        'Position', [.2 5 eWidth-.4 8],...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'middle',...
        'LineStyle', 'none' ,...
        'FontSize', 22,...
        'String', ' ',...
        'Interpreter', 'latex' ...
        );
    
    % Button to view animated euler rotation
    plotEulerButton = uicontrol;
    set(plotEulerButton,...
        'Parent', eFig,...
        'Units', 'centimeters',...
        'Position', [eWidth/2-2 2 4 1.2], ...
        'String', 'View Rotation', ...
        'FontSize', 14 ,...
        'Callback', @animateEuler_Callback ...
        );
    
    % Checkbox to add object to animation
    objectCheckbox = uicontrol;
    set(objectCheckbox,...
        'Parent', eFig,...
        'Units', 'centimeters',...
        'Style', 'checkbox',...
        'Position', [eWidth/2-1.5 1 4 .7] ,...
        'String', 'Add Object' ,...
        'Value', 0 ,...
        'FontSize', 12 ...
        );
    
    % Quaternion description
    axes(eAxes);
    t = text(2, 1, quatStr, 'FontSize', 20, 'Interpreter', 'latex');
    
    % Euler angle text
    [roll, pitch, yaw] = Q.toEuler();

    rstr = sprintf('$ \\phi = %.2f ^\\circ $', roll);
    pstr = sprintf('$ \\theta \\, = %.2f ^\\circ $', pitch);
    ystr = sprintf('$ \\psi = %.2f ^\\circ $', yaw);
    s = {rstr, ' ', pstr, ' ', ystr};
    set(eulerTextBox, 'String', s);
    
    aset = [];
    lines = [];
    function animateEuler_Callback(source, ~)
        % Create figure window for animation
        eAnimFig = figure(12);
        set(eAnimFig,... 
            'Units', 'centimeters',... 
            'Position', [4 2 20 20],...
            'Color', [0.65, 0.65, 0.65] ,...
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
        aset = GetAxisSet(12, ob);
        set(gca, 'Position', [-.3 -.3 1.6 1.6]);
        hold off;
        lines = [];
        hold on
        rotate3d on;
        light('Position', [1 0 1], 'Style', 'local');
        light('Position', [-1 0 1], 'Style', 'local');
        light('Position', [0 0 -1], 'Style', 'local');
        lighting gouraud;
        
        % Matrix to keep track of coordinate system during rotation
        cSystem = eye(3);
        % Cell array with handles to rotation matrix functions
        rmats = {@rotMatrixX, @rotMatrixY, @rotMatrixZ};
        angs = [yaw pitch roll];
        
        pause(2);
        
        % loop animation while window is open
        while ishandle(eAnimFig)
            % Rotate forward
            for j = 1:3
                rotateEuler(eAnimFig, cSystem(4-j,:), angs(j), j);
                cSystem = (rmats{4-j}(angs(j) * (pi/180))) * cSystem;
                pause(0.5);
            end
            
            pause(2);
            
            % Rotate backward
            for j = 1:3
                rotateEuler(eAnimFig, cSystem((j),:), -angs(4-j), -4+j);
                cSystem = (rmats{j}(-angs(4-j) * (pi/180))) * cSystem;
                pause(0.5);
            end
            
            pause(2);
        end
        
        
    end

    % ------------------------------------- %
    % --- X, Y, and Z Rotation matrices --- %
    % ---- to update coordinate system ---- %
    % ------------------------------------- %
    function M = rotMatrixX(an)
       M = [1 0 0; 0 cos(an) sin(an); 0 -sin(an) cos(an)]; 
    end

    function M = rotMatrixY(an)
       M = [cos(an) 0 -sin(an); 0 1 0; sin(an) 0 cos(an)]; 
    end

    function M = rotMatrixZ(an)
       M = [cos(an) sin(an) 0; -sin(an) cos(an) 0; 0 0 1]; 
    end


    % Function to perform rotation around single axis
    function rotateEuler(fighandle, ax, an, step)
        col = ['r','b','g'];
        lstyles = {'-', '--', '-.'};
        
        if step > 0 && ishandle(fighandle)
            for j=1:2:6
                adata = get(aset(j),{'Xdata','Ydata','Zdata'});
                mx = mean(adata{1},2);
                my = mean(adata{2},2);
                mz = mean(adata{3},2);
                lines(step,(j+1)/2) = line(...
                    'XData', mx,...
                    'YData', my,...
                    'ZData', mz,...
                    'Color', col((j+1)/2),...
                    'LineWidth', 1.4 ,...
                    'LineStyle', lstyles{step} ...
                );
            end
        end
        
        for j = 1:50
           if ishandle(fighandle), 
               rotate(aset, ax, an/50, [0 0 0]);
               if abs(an) > 1.0
                   pause(.02);
               end
           end
        end 
        
        if step < 0 && ishandle(fighandle)
            for j = 1:2:6
                delete(lines(-step,(j+1)/2));
            end
        end
    end
end

