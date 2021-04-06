function [fitresult, gof] = fit_gaussiano_id_sat(omega, y_omega)
%CREATEFIT(OMEGA,Y_OMEGA)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : omega
%      Y Output: y_omega
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 14-Sep-2020 12:52:42


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( omega, y_omega );

% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.Normalize = 'on';
opts.StartPoint = [100 -0.232926797500186 0.16960806249524];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'y_omega vs. omega', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'omega', 'Interpreter', 'none' );
ylabel( 'y_omega', 'Interpreter', 'none' );
grid on


