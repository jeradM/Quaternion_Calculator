function RotMatrixGUI( Q, quatStr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mWidth = 15;
    mHeight = 10;

    % Create Main Rotation Matrix Window
    mFig = figure;
    set(mFig,...
        'Units', 'centimeters',...
        'Position', [6 10 mWidth mHeight],...
        'Visible', 'on',...
        'Resize', 'off' ,...
        'WindowStyle', 'modal' ...
        );
    
    % Title
    mTitle = uicontrol;
    set(mTitle,...
        'Parent', mFig,...
        'Units', 'centimeters',...
        'Position', [0 mHeight-1.5 mWidth 1],...
        'Style', 'Text',...
        'String', 'Rotation Matrix',...
        'FontSize', 18 ...
        );
    
    % Hidden Axes for quaternion text object
    mAxes = axes;
    set(mAxes,...
        'Parent', mFig,...
        'Units', 'centimeters',...
        'Position', [0 6 mWidth 2] ,...
        'XLim', [0 mWidth],...
        'YLim', [0 2],...
        'Visible', 'off' ...
        );
    
    % Textbox for euler angles
    rmTextBox = annotation('textbox',... 
        'Units', 'centimeters',...
        'Position', [.2 .2 mWidth-.4 5.8],...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'middle',...
        'LineStyle', 'none' ,...
        'FontSize', 22,...
        'String', ' ',...
        'Interpreter', 'latex' ...
        );
    
    % Quaternion description
    axes(mAxes);
    text(2, 1, quatStr, 'FontSize', 20, 'Interpreter', 'latex')

    M = Q.toRotationMatrix();
    m = [M(1,:) M(2,:) M(3,:)];
    s = '$$M = \\left[ \\begin{tabular}{lll} %.2f & %.2f & %.2f \\\\ %.2f & %.2f & %.2f \\\\ %.2f & %.2f & %.2f \\end{tabular} \\right]$$';
    str = sprintf(s, m);
    rmTextBox.String = str;

end

