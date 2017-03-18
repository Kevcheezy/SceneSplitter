function [num , clipnums] = VideoClips( videofile , outfilename )

% -- Function --
% Based on mean RGB values changes outside +- a certain threshhold 
% and splits the original clip into mini clips depending on scene changes...

% -- Input args -- 
% videofile = videofilename ('Tennis.mp4')
% outfilename = base output filename (i.e. 'Tennis')

% -- Output --
% num = # of clips
% clipnums = vector of N elements that give the frame number from the input
%            video that begins each clip

% Read video file
v1 = VideoReader(videofile); % used for current frame
v2 = VideoReader(videofile); % used for next frame
numberOfFrames = v1.NumberOfFrames;
v1 = VideoReader(videofile);
frameLimit = numberOfFrames; % numberOfFrames --change here

% Get pixel size ONCE (assuming resolution doesnt change)
row = v1.Height;
column = v1.Width;
numPixels = row * column;

%Show frame
%figure; 

% Output vector
clipnums = [1];
sceneCounter = 1;

% Threshhold value that is between 1-256
threshholdValue = 3.75; % Experimentally calculated value through trial and error

% Write videos as processing
outfile = strcat(outfilename,'_1');
writer = VideoWriter(outfile,'MPEG-4');
open(writer);

% Initialize
currentFrameMean = zeros(3,frameLimit);
nextFrameMean = zeros(3,frameLimit);
currentTotalMean = 0;
nextTotalMean = 0;


% Process each frame to collect data
for frame = 1 : frameLimit-1
    if frame == 1
        % Initial frame
        currentFrame = readFrame(v1); % on first
        nextFrame = readFrame(v2); % on second
        nextFrame = readFrame(v2);
        
        % Display frames
        %image(currentFrame);
        %drawnow;
        %image(nextFrame);
        
        % Write frames to first video
        writeVideo(writer, currentFrame);
        % Write second frame, assuming no scene change now
        writeVideo(writer, nextFrame);
    else
        % Move forward once
        currentFrame = readFrame(v1);
        nextFrame = readFrame(v2);
        
        % Draw figure
        %image(currentFrame);
        %drawnow;
        
        % Get data for current frame
        for channel = 1 : 3
            currentFrameMean(channel, frame) = mean(mean(currentFrame(:,:,channel)));
        end
        currentTotalMean = (currentFrameMean(1, frame) + currentFrameMean(2, frame) + currentFrameMean(3, frame))/3;
        
        % Draw image
        %image(nextFrame);
        %drawnow;
        
        % Get data for next frame
        for channel = 1 : 3
            nextFrameMean(channel, frame) = mean(mean(nextFrame(:,:,channel)));
        end
        nextTotalMean = (nextFrameMean(1, frame) + nextFrameMean(2, frame) + nextFrameMean(3, frame))/3;

        % Check if new scene
        if (abs(currentTotalMean - nextTotalMean) > threshholdValue) | (abs(nextTotalMean - currentTotalMean) > threshholdValue)
            close(writer);
            sceneCounter = sceneCounter + 1;
            outfile = strcat(outfilename,'_' , num2str(sceneCounter));
            writer = VideoWriter(outfile,'MPEG-4');
            open(writer);
            writeVideo(writer, currentFrame);
            clipnums = [clipnums , frame];
        % Continue adding frames to current video
        else
            writeVideo(writer,currentFrame);
        end
    end
end
close(writer);
[ ~ , num] = size(clipnums); 
end

