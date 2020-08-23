classdef EE305Group1code < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        Curlcondition          matlab.ui.control.Label
        CalculateCurlButton    matlab.ui.control.Button
        K1Label                matlab.ui.control.Label
        k1value                matlab.ui.control.EditField
        K2Label                matlab.ui.control.Label
        k2value                matlab.ui.control.EditField
        K3Label                matlab.ui.control.Label
        k3value                matlab.ui.control.EditField
        Curlanswer             matlab.ui.control.Label
        C1Label                matlab.ui.control.Label
        c1value                matlab.ui.control.EditField
        C2Label                matlab.ui.control.Label
        c2value                matlab.ui.control.EditField
        C3Label                matlab.ui.control.Label
        c3value                matlab.ui.control.EditField
        ROTATIONALLampLabel    matlab.ui.control.Label
        ROTATIONALLamp         matlab.ui.control.Lamp
        IRROTATIONALLampLabel  matlab.ui.control.Label
        IRROTATIONALLamp       matlab.ui.control.Lamp
        phiLabel               matlab.ui.control.Label
        phivalues              matlab.ui.control.TextArea
        rLabel                 matlab.ui.control.Label
        rvalues                matlab.ui.control.TextArea
        zTextAreaLabel         matlab.ui.control.Label
        zvalues                matlab.ui.control.TextArea
        NextButton             matlab.ui.control.Button
        PreviousButton         matlab.ui.control.Button
        IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel  matlab.ui.control.Label
        Image                  matlab.ui.control.Image
        EnterthecoefficientsofthevectorfieldLabel  matlab.ui.control.Label
        INCYLINDRICALCOORDINATESrphizLabel  matlab.ui.control.Label
        r0Label                matlab.ui.control.Label
        phi2Label              matlab.ui.control.Label
    end

     
properties(Access = public)
    rans;
    phians;
    zans;
    i;
    
end       

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateCurlButton
        function CalculateCurlButtonPushed(app, event)
            syms r phi z
            coeff1 = str2sym(app.k1value.Value);
            coeff2 = str2sym(app.k2value.Value);
            coeff3 = str2sym(app.k3value.Value);
            curl1 = ((diff(coeff3,phi)/r))- diff(coeff2,z);
            curl2 = diff(coeff1,z) - diff(coeff3,r);
            curl3 = (diff(r*coeff2,r)-diff(coeff1,phi))/r;
            curlans = [curl1, curl2, curl3];
            curlstr = arrayfun(@char, curlans, 'uniform', 0);
            app.c1value.Value = curlstr{1};
            app.c2value.Value = curlstr{2};
            app.c3value.Value = curlstr{3};
            if (curl1 == 0) && (curl2 == 0) && (curl3 == 0)
                app.ROTATIONALLamp.Enable = 'off';
                app.IRROTATIONALLamp.Enable = 'on';
                app.IRROTATIONALLamp.Color = 'green';
            else
                app.ROTATIONALLamp.Enable = 'on';
                app.IRROTATIONALLamp.Enable = 'off';
                app.ROTATIONALLamp.Color = 'red';                
            end
            eqns = [curl1 == 0, curl2 == 0, curl3 == 0];
            S = solve(eqns,r,phi,z, 'ReturnConditions', true);   
            app.rans = arrayfun(@char, S.r, 'uniform', 0);
            app.phians = arrayfun(@char, S.phi, 'uniform', 0);
            app.zans = arrayfun(@char, S.z, 'uniform', 0);
            app.i = 0;
            app.phivalues.Value = '';
            app.rvalues.Value = '';
            app.zvalues.Value = '';
            %cos(phi)*r*z^2 3
            %r*(z^2)*sin(phi) 2
            %r^2*cos(phi) 1
            
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            if (app.i < length(app.phians))
                app.i = app.i + 1;
                app.phivalues.Value = app.phians{app.i};
                app.rvalues.Value = app.rans{app.i};
                app.zvalues.Value = app.zans{app.i};
            
            end
        end

        % Button pushed function: PreviousButton
        function PreviousButtonPushed(app, event)
             if (app.i > 1)
                app.i = app.i - 1; 
                app.phivalues.Value = app.phians{app.i};
                app.rvalues.Value = app.rans{app.i};
                app.zvalues.Value = app.zans{app.i};
                
             end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.6353 0.8 0.9098];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create Curlcondition
            app.Curlcondition = uilabel(app.UIFigure);
            app.Curlcondition.FontName = 'Microsoft YaHei';
            app.Curlcondition.Position = [54 125 383 22];
            app.Curlcondition.Text = 'The curl will be zero for the following conditions of r, phi and z   ';

            % Create CalculateCurlButton
            app.CalculateCurlButton = uibutton(app.UIFigure, 'push');
            app.CalculateCurlButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateCurlButtonPushed, true);
            app.CalculateCurlButton.Position = [290 265 100 22];
            app.CalculateCurlButton.Text = 'Calculate Curl';

            % Create K1Label
            app.K1Label = uilabel(app.UIFigure);
            app.K1Label.HorizontalAlignment = 'right';
            app.K1Label.Position = [70 308 25 22];
            app.K1Label.Text = 'K1';

            % Create k1value
            app.k1value = uieditfield(app.UIFigure, 'text');
            app.k1value.Position = [110 308 100 22];

            % Create K2Label
            app.K2Label = uilabel(app.UIFigure);
            app.K2Label.HorizontalAlignment = 'right';
            app.K2Label.Position = [251 308 25 22];
            app.K2Label.Text = 'K2';

            % Create k2value
            app.k2value = uieditfield(app.UIFigure, 'text');
            app.k2value.Position = [290 308 100 22];

            % Create K3Label
            app.K3Label = uilabel(app.UIFigure);
            app.K3Label.HorizontalAlignment = 'right';
            app.K3Label.Position = [454 308 25 22];
            app.K3Label.Text = 'K3';

            % Create k3value
            app.k3value = uieditfield(app.UIFigure, 'text');
            app.k3value.Position = [494 308 100 22];

            % Create Curlanswer
            app.Curlanswer = uilabel(app.UIFigure);
            app.Curlanswer.FontName = 'Microsoft YaHei';
            app.Curlanswer.Position = [54 211 440 22];
            app.Curlanswer.Text = 'The curl of the vector field is a vector field with coefficients C1, C2 & C3 is:';

            % Create C1Label
            app.C1Label = uilabel(app.UIFigure);
            app.C1Label.HorizontalAlignment = 'right';
            app.C1Label.Position = [70 175 25 22];
            app.C1Label.Text = 'C1';

            % Create c1value
            app.c1value = uieditfield(app.UIFigure, 'text');
            app.c1value.Position = [110 175 100 22];

            % Create C2Label
            app.C2Label = uilabel(app.UIFigure);
            app.C2Label.HorizontalAlignment = 'right';
            app.C2Label.Position = [251 175 25 22];
            app.C2Label.Text = 'C2';

            % Create c2value
            app.c2value = uieditfield(app.UIFigure, 'text');
            app.c2value.Position = [290 175 100 22];

            % Create C3Label
            app.C3Label = uilabel(app.UIFigure);
            app.C3Label.HorizontalAlignment = 'right';
            app.C3Label.Position = [454 175 25 22];
            app.C3Label.Text = 'C3';

            % Create c3value
            app.c3value = uieditfield(app.UIFigure, 'text');
            app.c3value.Position = [494 175 100 22];

            % Create ROTATIONALLampLabel
            app.ROTATIONALLampLabel = uilabel(app.UIFigure);
            app.ROTATIONALLampLabel.HorizontalAlignment = 'right';
            app.ROTATIONALLampLabel.FontName = 'Microsoft YaHei';
            app.ROTATIONALLampLabel.FontWeight = 'bold';
            app.ROTATIONALLampLabel.Position = [97 265 87 22];
            app.ROTATIONALLampLabel.Text = 'ROTATIONAL';

            % Create ROTATIONALLamp
            app.ROTATIONALLamp = uilamp(app.UIFigure);
            app.ROTATIONALLamp.Position = [202 265 20 20];
            app.ROTATIONALLamp.Color = [1 0 0];

            % Create IRROTATIONALLampLabel
            app.IRROTATIONALLampLabel = uilabel(app.UIFigure);
            app.IRROTATIONALLampLabel.HorizontalAlignment = 'right';
            app.IRROTATIONALLampLabel.FontName = 'Microsoft YaHei';
            app.IRROTATIONALLampLabel.FontWeight = 'bold';
            app.IRROTATIONALLampLabel.Position = [465 264 100 22];
            app.IRROTATIONALLampLabel.Text = 'IRROTATIONAL';

            % Create IRROTATIONALLamp
            app.IRROTATIONALLamp = uilamp(app.UIFigure);
            app.IRROTATIONALLamp.Position = [580 264 20 20];

            % Create phiLabel
            app.phiLabel = uilabel(app.UIFigure);
            app.phiLabel.HorizontalAlignment = 'right';
            app.phiLabel.FontName = 'Microsoft YaHei';
            app.phiLabel.Position = [250 86 25 22];
            app.phiLabel.Text = 'phi';

            % Create phivalues
            app.phivalues = uitextarea(app.UIFigure);
            app.phivalues.Position = [319 50 125 60];

            % Create rLabel
            app.rLabel = uilabel(app.UIFigure);
            app.rLabel.HorizontalAlignment = 'right';
            app.rLabel.FontName = 'Microsoft YaHei';
            app.rLabel.Position = [57 86 25 22];
            app.rLabel.Text = 'r ';

            % Create rvalues
            app.rvalues = uitextarea(app.UIFigure);
            app.rvalues.Position = [98 50 112 60];

            % Create zTextAreaLabel
            app.zTextAreaLabel = uilabel(app.UIFigure);
            app.zTextAreaLabel.HorizontalAlignment = 'right';
            app.zTextAreaLabel.Position = [455 86 25 22];
            app.zTextAreaLabel.Text = 'z';

            % Create zvalues
            app.zvalues = uitextarea(app.UIFigure);
            app.zvalues.Position = [500 50 106 60];

            % Create NextButton
            app.NextButton = uibutton(app.UIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Position = [344 15 100 22];
            app.NextButton.Text = 'Next';

            % Create PreviousButton
            app.PreviousButton = uibutton(app.UIFigure, 'push');
            app.PreviousButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousButtonPushed, true);
            app.PreviousButton.Position = [196 15 100 22];
            app.PreviousButton.Text = 'Previous';

            % Create IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel
            app.IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel = uilabel(app.UIFigure);
            app.IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel.FontName = 'Bookman Old Style';
            app.IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel.FontSize = 17;
            app.IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel.FontWeight = 'bold';
            app.IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel.Position = [70 421 536 22];
            app.IRROTATIONALVECTORFIELDCONDITIONCALCULATORLabel.Text = 'IRROTATIONAL VECTOR FIELD CONDITION CALCULATOR';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.VerticalAlignment = 'top';
            app.Image.Position = [239 345 202 22];
            app.Image.ImageSource = 'Capture111.PNG';

            % Create EnterthecoefficientsofthevectorfieldLabel
            app.EnterthecoefficientsofthevectorfieldLabel = uilabel(app.UIFigure);
            app.EnterthecoefficientsofthevectorfieldLabel.FontName = 'Microsoft YaHei';
            app.EnterthecoefficientsofthevectorfieldLabel.Position = [54 345 241 22];
            app.EnterthecoefficientsofthevectorfieldLabel.Text = 'Enter the coefficients of the vector field  ';

            % Create INCYLINDRICALCOORDINATESrphizLabel
            app.INCYLINDRICALCOORDINATESrphizLabel = uilabel(app.UIFigure);
            app.INCYLINDRICALCOORDINATESrphizLabel.FontName = 'Bookman Old Style';
            app.INCYLINDRICALCOORDINATESrphizLabel.FontSize = 13;
            app.INCYLINDRICALCOORDINATESrphizLabel.Position = [176 391 290 22];
            app.INCYLINDRICALCOORDINATESrphizLabel.Text = 'IN CYLINDRICAL COORDINATES ( r, phi, z )';

            % Create r0Label
            app.r0Label = uilabel(app.UIFigure);
            app.r0Label.FontName = 'Microsoft YaHei';
            app.r0Label.Position = [55 65 41 22];
            app.r0Label.Text = '(r ÿ 0)';

            % Create phi2Label
            app.phi2Label = uilabel(app.UIFigure);
            app.phi2Label.FontName = 'Microsoft YaHei';
            app.phi2Label.Position = [221 65 97 22];
            app.phi2Label.Text = ' (0 ÿ  phi ÿ  2ÿ)';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = EE305Group1code

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end