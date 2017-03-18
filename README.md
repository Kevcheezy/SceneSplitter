# SceneSplitter

MATLAB program that takes in the name of a video file ('SampleVideo.mp4') and a base output filename ('Scene_Part'), and produces video clips ('Scene_Part_1.mp4', 'Scene_Part_2.mp4', ... ) occuring every scene change of the video.

Program determines scene changes based on a change of intensity values above a certain threshhold from frame-to-frame.
