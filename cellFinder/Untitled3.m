imgin = imread('test.jpg'); % read in image
imgblue = imgin(:,:,3) ; % blue, nuclei only signal
imgred = imgin(:,:,1) ; % red, neuron only signal

d100 = strel('disk', 100);
d4 = strel('disk', 4);
d20 = strel('disk', 20);
d10 = strel('disk', 10);
d7 = strel('disk', 7);

%% all DAPI cell count
imgblue_T = imtophat(imgblue, d100);  %background correction

int_mask = (imgblue_T > 30) ;  % creates intensity mask, restricted to dapi positive area
int_mask2 = imclose(int_mask, d4); % removes small holes in nucleur mask
int_mask2 = ~bwareaopen(~int_mask2, 100);  %removes objects below cutoff

intent2 = imopen(imgblue, d20);  %blurs image
intent2o = intent2;
intent2(~int_mask2) = 0;  % remove areas that do not meet intensity thresholds

intentC = imopen(intent2, d10);  % flattens peaks. cells below kernel size are removed
maxima = imregionalmax(intentC, 8);  % finds maxima associated with flattened peaks
maximaN = maxima & int_mask2;   % ensures maxima fall entirely within positive mask, needed to reconstruct
reconD = imreconstruct(maximaN, maxima);  % final cell markers

%% Find red positive cells
r_sub = imtophat(imgred, d100);  %background correction
r_pos = r_sub > 50;  %mask for red positive areas
r_posC = imclose(r_pos, d7);  %consolidate positive mask
rb_coloc = r_posC & reconD;  %Find overlap with nuclei mask
rb_colocO = bwareaopen(rb_coloc, 200);  %remove small objects
reconFT = imreconstruct(rb_colocO, reconD);  %mask of cells co-localizing DAPI and neuronal marker
