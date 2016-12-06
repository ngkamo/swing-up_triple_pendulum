# Swing-up of a triple arm inverted pendulum
Winter semester project 2016 - EPFL

## Useful resources
- Simulating linear systems [ctms.engin.umich.edu](http://ctms.engin.umich.edu/CTMS/index.php?aux=Extras_lsim)
- Full tutorial on LQR controllers for a simple inverted cart pendulum [ctms.engin.umich.edu/LQRpendulum](http://ctms.engin.umich.edu/CTMS/index.php?example=InvertedPendulum&section=ControlStateSpace)
- LQR control theory, [Control and Dynamical Systems CALTECH](http://www.cds.caltech.edu/~murray/courses/cds110/wi06/lqr.pdf)
- Another LQR control theory, [Pieter Abbeel UC Berkeley ](https://people.eecs.berkeley.edu/~pabbeel/cs287-fa12/slides/LQR.pdf)
- Linearization using Symbolic Toolbox of Matlab [Youtube Video](https://www.youtube.com/watch?v=KXQKlpMXJYI)

## References
- Swing-up control of a triple pendulum on a cart with experimental validation [Glück, Eder, Kugi](http://www.acin.tuwien.ac.at/fileadmin/cds/pre_post_print/glueck2013.pdf)
- Optimal Control of Double Inverted Pendulum Using LQRController [Yadav, Sharma, Singh](https://fr.scribd.com/document/83077631/Optimal-Control-of-Double-Inverted-Pendulum-Using-LQR-Controller)
- LQR control for stabilizing triple link inverted pendulum system [Sehgal, Tiwari](https://www.researchgate.net/publication/261075270_LQR_control_for_stabilizing_triple_link_inverted_pendulum_system)

## Roadmap
- [x] Replacing point masses by solid links
- [x] LQR for upright equilibrium stabilization
- [ ] LQR swing-up (trajectory following) phase using same **K** as for the upright stabilization
- [ ] LQR swing-up (trajectory following) phase using several **K** during trajectory
- [ ] Clean code and folders

## Exporting Matlab figures with publication quality
![Graph sample](https://github.com/ngkamo/swing-up_triple_pendulum/blob/master/AAA_TRIPLEPENDULUM_CART_FINAL2_CONTROL/illustrations/position_angle_cart.png?raw=true)

```matlab
close
figure('Units','centimeters')
plot(t_span,[zhistory(:,2) zhistory(:,4) zhistory(:,6) zhistory(:,8)], 'LineWidth',2)
lgd1 = legend({'$\dot x_{cart}$' '$\dot\theta_1$' '$\dot\theta_2$' '$\dot\theta_3$'},'Interpreter','latex','FontSize', 14);

title('Speed of the cart and angular speed of links')
xlabel('Time [s]')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 11 9]);
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('speed_angle_cart','-dpng','-r300');
```
