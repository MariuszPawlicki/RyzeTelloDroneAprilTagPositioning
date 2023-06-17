function [translated_pose] = calculateposes(image_dir, image_size, tag_size, focal_length, sensor_size)

image = image_dir;
focal_length_xy = [focal_length*image_size(1)/sensor_size(1) focal_length*image_size(2)/sensor_size(2)];
principal_point = [image_size(2)/2 image_size(1)/2];
intrinsics = cameraIntrinsics(focal_length_xy , principal_point , image_size);

image = undistortImage(image,intrinsics,OutputView="same");

[~ , ~ , pose] = readAprilTag(image , "tag36h11" , intrinsics , tag_size);

if isempty(pose)
    translated_pose = -1;
else
    translated_pose = [pose.Translation];
end

end