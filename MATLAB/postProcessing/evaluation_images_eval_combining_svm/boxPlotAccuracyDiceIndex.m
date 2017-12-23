
function boxPlotAccuracyDiceIndex(diceCoeff_data, Accuracy_data, savePlot)
	
	index = ["Max","Sum","MajorityVote"];

	% Dice Coeeficient
	f2=figure;boxplot (diceCoeff_data, index);
	title('Dice Coefficient Comparision');
	ylabel('Dice Coefficient');
	xlabel('Combining methods');
	
	for i=1:size(diceCoeff_data,2)
		text( i-0.2,median(diceCoeff_data(:,i))+ 0.008,num2str((median(diceCoeff_data(:,i)))), 'Color','g','FontWeight','bold', 'FontSize',12);
		text( i-0.2,mean(diceCoeff_data(:,i))-0.008,num2str((mean(diceCoeff_data(:,i)))), 'Color',[0.0,0.0,0.0],'FontWeight','bold', 'FontSize',12)

	end
	lines = findobj(f2, 'type', 'line', 'Tag', 'Median');
	set(lines, 'Color', 'g');

	hold on;plot(median(diceCoeff_data), 's', 'MarkerSize',4,...
		'MarkerEdgeColor','g',...
		'MarkerFaceColor','g')

	hold on;plot(mean(diceCoeff_data), 'dg', 'MarkerSize',4,...
		'MarkerEdgeColor','black',...
		'MarkerFaceColor',[0.0,0.0,0.0])
	legend({'median','mean'}, 'FontWeight','bold', 'FontSize',12)
    if savePlot
        print(f2,'DC_boxplot', '-dpng', '-r800' )
    end



	% Accuracy
	f1=figure;boxplot (Accuracy_data, index);
	title('Accuracy in ROI');
	ylabel('Accuracy');
	xlabel('Combining Method');

	for i=1:size(Accuracy_data,2)

		text( i-0.2,median(Accuracy_data(:,i))+ 0.008,num2str((median(Accuracy_data(:,i)))), 'Color','g','FontWeight','bold', 'FontSize',12)
		text( i-0.2,mean(Accuracy_data(:,i))-0.008,num2str((mean(Accuracy_data(:,i)))), 'Color',[0.0,0.0,0.0],'FontWeight','bold', 'FontSize',12)

	end

	lines = findobj(f1, 'type', 'line', 'Tag', 'Median');
	set(lines, 'Color', 'g');

	hold on;plot(median(Accuracy_data), 's', 'MarkerSize',4,...
		'MarkerEdgeColor','g',...
		'MarkerFaceColor','g')

	hold on;plot(mean(Accuracy_data), 'dg','MarkerSize',4,...
		'MarkerEdgeColor','black',...
		'MarkerFaceColor',[0.0,0.0,0])

	legend({'median','mean'}, 'FontWeight','bold', 'FontSize',12)
    
    if savePlot
        print(f1, 'accuracy_boxplot', '-dpng', '-r800' )
    end
end