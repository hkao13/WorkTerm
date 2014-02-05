function mtHotKeyHandler;

global guiH;
global trak;
global gv;

hotKey = uint8(get( guiH.fig, 'CurrentCharacter' ));

iFrame = trak.iFrame;
nFrames = trak.nF*gv.fpf;

if ~isempty( hotKey ),
    switch hotKey,
        %hokeys for manual digitizing single markers. 
        %markers 1 - 10 are the row of numbers 1 - 0, 
        %markers 2 - 21 are the row of keys q - [
    case '1',
        manualDigitize 1;
    case '2',
        manualDigitize 2;
    case '3',
        manualDigitize 3;
    case '4',
        manualDigitize 4;
    case '5',
        manualDigitize 5;
    case '6',
        manualDigitize 6;
    case '7',
        manualDigitize 7;
    case '8',
        manualDigitize 8;
    case '9',
        manualDigitize 9;
    case '0',
        manualDigitize 10;
    case 'q',
        manualDigitize 11;
    case 'w',
        manualDigitize 12;
    case 'e',
        manualDigitize 13;
    case 'r',
        manualDigitize 14;
    case 't',
        manualDigitize 15;
    case 'y',
        manualDigitize 16;
    case 'u',
        manualDigitize 17;
    case 'i',
        manualDigitize 18;
    case 'o',
        manualDigitize 19;
    case 'p',
        manualDigitize 20;
    case '[',
        manualDigitize 21;
    case {char(28), char(27)}
        mtGUI('back1');
    case {char(29), char(96)}
        mtGUI('forward1');
%arrow keys for frame advancement        
    case char(30),
        iFrame = iFrame + round( .2*gv.fps*gv.fpf );
        iFrame(iFrame > nFrames) = nFrames;
        trak.iFrame = iFrame;
        trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
        %field number
        trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;
        mtGUI('updateDisplay');
    case char(31),
        iFrame = iFrame - round( .2*gv.fps*gv.fpf );
        iFrame(iFrame < 1) = 1;
        trak.iFrame = iFrame;
        trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
        %field number
        trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;
        mtGUI('updateDisplay');
    end
end

