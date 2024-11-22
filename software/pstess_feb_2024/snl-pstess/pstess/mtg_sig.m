function mtg_sig(t,k)
% Syntax: mtg_sig(t,k)
%
% Purpose: Defines modulation signal for turbine power reference

%-----------------------------------------------------------------------------%

global g;  % declaring struct of global variables

if (g.tg.n_tg_tot ~= 0)
    g.tg.tg_sig(:,k) = zeros(g.tg.n_tg_tot,1);

    % if (t > 1.0 && t < 1.5)
    %     g.tg.tg_sig(1,k) = g.tg.tg_sig(1,1) + 0.20;
    % end
end

end  % function end

% eof
