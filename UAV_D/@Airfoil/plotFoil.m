function plotFoil(obj)
figure;
plot(obj.Geometry.x_c,obj.Geometry.y_c,'k'); 
axis equal;
xlabel('x/c');
ylabel('y/c');
end