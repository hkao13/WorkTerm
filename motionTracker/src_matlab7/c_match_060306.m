% color matching through calculation of the color spectrum, as described in
% the "IMAQ vision algorithms" pdf file.
% the output is a [x y] vector containing the estimated center of the
% marker (peak of the filter2 function)


function peak = c_match(mask,image);

res=0; res2=0; res3=0;
[height_image, width_image, dummy]=size(image);
[height_mask, width_mask, dummy]=size(mask);

sensitivity=4; % number of colors of the colormap
step=8;

% create an indexed image and a colormap from the reference
[ref,spectrum]=rgb2ind(mask,sensitivity,'nodither');

for i=[1:step:height_image-(height_mask-1)]
    for j=[1:step:width_image-(width_mask-1)]

        % then compare the distribution of the indexed image with that
        % of the targe(covariance)
        X=rgb2ind(image(i:i+height_mask-1,j:j+width_mask-1,:),spectrum,'nodither');

        ref=double(reshape(ref,1,[]));
        X=double(reshape(X,1,[]));

        ref=sort(ref);
        X=sort(X);
        temp=corrcoef(ref,X);
        res3(i,j)=abs(temp(2,1));

    end
end

[a,lines]=max(res3);
[b,col]=max(a);
% figure;
% imshow(res3(1:step:end,1:step:end)./max(max(res3)))
match=[lines(col);col];

outside=8;

x=max(match(1)-outside,1);
y=max(match(2)-outside,1);
image_gray=rgb2gray(image(x:min(x+height_mask+2*outside,height_image),y:min(y+2*outside+width_mask,width_image),:));
mask_gray=rgb2gray(mask);

% %sharpens the grayscale image and mask
% sharp=[0 -1 0; -1 5 -1;0 -1 0];
% mask_gray=filter2(sharp,mask_gray,'valid');
% image_gray=filter2(sharp,image_gray,'valid');
% mask_gray=mask_gray./max(max(mask_gray));
% image_gray=image_gray./max(max(image_gray));


%2D correlation
I=filter2(mask_gray,image_gray);

%searching the max
[a,lines]=max(I);
[b,col]=max(a);
peak=[lines(col),col];

%imshow(image(x+peak(1)-floor(height_mask/2):x+peak(1)+ceil(height_mask/2),y+peak(2)-floor(width_mask/2):y+peak(2)+ceil(width_mask/2),:));



