# Swing-up of a triple arm inverted pendulum using time reversal
Winter semester project 2016 - EPFL

## Useful resources
- Control tutorials for MATLAB and Simulink [ctms.engin.umich.edu](http://ctms.engin.umich.edu/CTMS/index.php?aux=Home)
- Feedback systems: Introduction [Karl J. Åström and Richard M. Murray](http://www.cds.caltech.edu/~murray/amwiki/index.php?title=Main_Page)
- Modelling, analysis and control of linear systems [O. Sename, Grenoble INP](https://www.gipsa-lab.grenoble-inp.fr/~o.sename/docs/ME_auto.pdf)
- Dynamic simulation MATLAB [Cornell University](http://ruina.tam.cornell.edu/research/topics/locomotion_and_robotics/ranger/ranger_paper/Reports/Ranger_Robot/control/simulator/doublependulum.html)

### LQR controller
- Controlling an Inverted pendulum using state space modeling method (step by step guide) [Tsegazeab Shishaye](https://www.academia.edu/4468049/Controlling_an_Inverted_pendulum_using_state_space_modeling_method_step_by_step_design_guide_for_control_students_)
- Full tutorial on LQR controllers for a simple inverted cart pendulum [ctms.engin.umich.edu/LQRpendulum](http://ctms.engin.umich.edu/CTMS/index.php?example=InvertedPendulum&section=ControlStateSpace)
- LQR control theory, [Control and Dynamical Systems CALTECH](http://www.cds.caltech.edu/~murray/courses/cds110/wi06/lqr.pdf)
- Another LQR control theory, [Pieter Abbeel UC Berkeley ](https://people.eecs.berkeley.edu/~pabbeel/cs287-fa12/slides/LQR.pdf)
- Linearization using Symbolic Toolbox of Matlab [Youtube Video](https://www.youtube.com/watch?v=KXQKlpMXJYI)
- Linear Quadratic Regulator [Richard M. Murray 11.01.2006](http://www.cds.caltech.edu/~murray/courses/cds110/wi06/L2-1_LQR.pdf)

### Lagrange formalism
- Sutdy of a coupled pendulum [Mathieu Schaller EPFL](https://documents.epfl.ch/users/m/ms/mschalle/www/SiteWeb/ComputationalPhysics/physNum_report3.pdf)
- Simple pendulum case [Physics UNICE (FR)](http://physique.unice.fr/sem6/2011-2012/PagesWeb/PT/Pendule/study1_simple.html)
- Lagrange equations with MATLAB [Yun](http://youngmok.com/lagrange-equation-by-matlab-with-examples/)

## References
- Systèmes dynamiques, ME-221 [Dominique Bonvin](http://la.epfl.ch/page-53050.html)
- State space control, LQR and observer [Roland Büchi](https://books.google.ch/books?id=JrofAgAAQBAJ&dq=state+space+control+lqr+and+observer+b%C3%BCchi&hl=fr&source=gbs_navlinks_s)
- Swing-up control of a triple pendulum on a cart with experimental validation [Glück, Eder, Kugi](http://www.acin.tuwien.ac.at/fileadmin/cds/pre_post_print/glueck2013.pdf)
- Stabilization of triple link inverted pendulum system based  on LQR control technique [Gupta, Bansal, Singh]()
- Robust stabilization of a triple inverted pendulum cart [Medrano-Cerda]()
- Swinging up a pendulum by energy control [Åström and Furuta](http://www.sciencedirect.com/science/article/pii/S0005109899001405)
- Optimal Control of Double Inverted Pendulum Using LQRController [Yadav, Sharma, Singh](https://fr.scribd.com/document/83077631/Optimal-Control-of-Double-Inverted-Pendulum-Using-LQR-Controller)
- LQR control for stabilizing triple link inverted pendulum system [Sehgal, Tiwari](https://www.researchgate.net/publication/261075270_LQR_control_for_stabilizing_triple_link_inverted_pendulum_system)

## Roadmap
- [x] Replacing point masses by solid links
- [x] LQR for upright equilibrium stabilization
- [x] Change the linearization state-space model for the new mass links and length
- [x] LQR swing-up (trajectory following) phase using same **K** as for the upright stabilization (04.01.2017)
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
