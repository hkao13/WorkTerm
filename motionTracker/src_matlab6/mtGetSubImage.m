function curImage = mtGetSubImage( fullImage, videoFormat, iField );
%usage: curImage = getSubImage (videoFormat, iField);
% this function extracts subImages from a multiplexed video image; 

global gv;

sepFields = gv.sepFields;
if isempty( sepFields ),
    curImage = fullImage;
    return;
end
%This patch added on 9/8/2003 by DJW
%the firstField tag is needed to specify the field dominance for interlaced
%images. This only applies when seperating the fields 
% (e.g. gv.sepFields = Seperate)
%the patch only applies to 60 field per second video: NOT FOR HIGH SPEED
if ~isfield(gv, 'firstField'),
    gv.firstField = 'Lower';
end
%The default mode is lower field first as described below:
%NOTES ON INTERLACED IMAGES:
%The even fields are sampled first (lower field). For the high-speed video, the field order proceeds as follows:
% 120 fps (WIDE)
%       Field 1: sub image taken from rows 2:219 of the original image, odd fields of subimage replaced with even fields
%       Field 2: sub image taken from rows 262:479 of the original image, odd fields of subimage replaced with even fields
%       Field 3: sub image taken from rows 1:219 of the original image, even fields of subimage replaced with odd fields
%       Field 4: sub image taken from rows 261:479 of the original image, even fields of subimage replaced with odd fields
% 120 fps (TALL)
%       Field 1: sub image taken from rows 1:476, columns 9:300 of the original image, odd fields of subimage replaced with even fields
%       Field 2: sub image taken from rows 1:476, columns 309:600 of the original image, odd fields of subimage replaced with even fields
%       Field 3: sub image taken from rows 1:476, columns 9:300 of the original image, even fields of subimage replaced with odd fields
%       Field 4: sub image taken from rows 1:476, columns 309:600 of the original image, even fields of subimage replaced with odd fields
%       
% 240 fps (UNKNOWN YET) 290 horizontal, pixels, 184 vertical pixels
%       Field 1: sub image taken from rows 2:185 of the original image, even fields of subimage replaced with odd fields
%       Field 2: sub image taken from rows 2:185 of the original image, even fields of subimage replaced with odd fields
%       Field 3: sub image taken from rows 186:379 of the original image, odd fields of subimage replaced with even fields
%       Field 4: sub image taken from rows 186:379 of the original image, odd fields of subimage replaced with even fields
%       

switch sepFields,
case 'Merged', 
    %USE this for merging the interlaced fields
    if videoFormat == 3 | videoFormat == 7,
        curImage = fullImage;

    elseif videoFormat == 4, %120 fps WIDE
        curImage = [];
        if iField == 1, %subimage 1 (even fields)
            topImage = fullImage(2:2+gv.nVp-1, :, :);
            botImage = fullImage(262:262+gv.nVp-1, :, :);
            curImage = botImage;
            curImage(2:2:gv.nVp,:,:) = topImage(1:2:end,:,:);
        elseif iField == 2, %subimage 2 (odd fields)
            topImage = fullImage(1:1+gv.nVp-1, :, :);
            botImage = fullImage(263:263+gv.nVp-1, :, :);
            curImage = botImage;
            curImage(1:2:gv.nVp,:,:) = topImage(2:2:end,:,:);
        end
        
    %NOTE: cannot merge format 5 (120 fps, TALL) field 1 and field 2 use
    %the same horizontal scan lines, therefore there is a large time delay
    %between the odd and even scan lines in each panel (left and right)
    elseif videoFormat == 6,
        if iField == 1,
            curImage = fullImage(2:2+gv.nVp-1, 10:10+gv.nHp-1, :);
        elseif iField == 2,
            curImage = fullImage(2:2+gv.nVp-1, 310:310+gv.nHp-1, :);
        elseif iField == 3,
            curImage = fullImage(186:186+gv.nVp-1, 10:10+gv.nHp-1, :);
        elseif iField == 4,
            curImage = fullImage(186:186+gv.nVp-1, 310:310+gv.nHp-1, :);
        end
    end
    
case 'Seperate',
    %USE this for seperating the interlaced fields
    if videoFormat == 3 | videoFormat == 7,
        curImage = fullImage;
        switch gv.firstField,
            case 'Upper',
                if iField == 1, %replace lower (even) fields with upper (odd) fields
                    curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
                else %replace upper (odd) fields with lower (even) fields
                    curImage(1:2:end, :, :) = curImage(2:2:end, :, :);
                end
            otherwise, 
                if iField == 1, %replace upper (odd) fields with lower (even) fields
                    curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
                else %replace lower (even) fields with upper (odd) fields
                    curImage(2:2:end, :, :) = curImage(1:2:end, :, :);
                end
        end
        
    elseif videoFormat == 4, %120 fps WIDE
        if iField == 1, %TOP: use even (lower) fields, replace odd fields
            curImage = fullImage(2:2+gv.nVp-1, :, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
            
        elseif iField == 2, %BOTTOM: use even (lower) fields, replace odd fields
            curImage = fullImage(262:262+gv.nVp-1, :, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
            
        elseif iField == 3, %TOP: use odd (upper) fields, replace even fields
            curImage = fullImage(2:2+gv.nVp-1, :, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
            
        elseif iField == 4, %BOTTOM: use odd (upper) fields, replace even fields
            curImage = fullImage(262:262+gv.nVp-1, :, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
        end
                
    elseif videoFormat == 5, %120 fps TALL
        if iField == 1, %lower fields, left panel
            curImage = fullImage(1:476, 9:300, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
            
        elseif iField == 2, %lower fields, right panel
            curImage = fullImage(1:476, 309:600, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
            
        elseif iField == 3, %odd (Upper) fields, left panel
            curImage = fullImage(1:476, 9:300, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
            
        elseif iField == 4, %odd (upper) fields, right panel
            curImage = fullImage(1:476, 309:600, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
        end
        
    elseif videoFormat == 6,
        if iField == 1,
            curImage = fullImage(2:2+gv.nVp-1, 10:10+gv.nHp-1, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
        elseif iField == 2,
            curImage = fullImage(2:2+gv.nVp-1, 310:310+gv.nHp-1, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
        elseif iField == 3,
            curImage = fullImage(186:186+gv.nVp-1, 10:10+gv.nHp-1, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
        elseif iField == 4,
            curImage = fullImage(186:186+gv.nVp-1, 310:310+gv.nHp-1, :);
            curImage(2:2:end,:,:) = curImage(1:2:end, :, :);
        elseif iField == 5,
            curImage = fullImage(2:2+gv.nVp-1, 10:10+gv.nHp-1, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
        elseif iField == 6,
            curImage = fullImage(2:2+gv.nVp-1, 310:310+gv.nHp-1, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
        elseif iField == 7,
            curImage = fullImage(186:186+gv.nVp-1, 10:10+gv.nHp-1, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
        elseif iField == 8,
            curImage = fullImage(186:186+gv.nVp-1, 310:310+gv.nHp-1, :);
            curImage(1:2:end,:,:) = curImage(2:2:end, :, :);
        end
    end
end

