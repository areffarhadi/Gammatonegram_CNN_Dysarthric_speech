================================================================================

Alexey Sholokhov, Md Sahidullah and Tomi Kinnunen, "Semi-Supervised Speech 
Activity Detection with an Application to Automatic Speaker Verification", 
to appear in Computer Speech & Language.

(C) Copyright University of Eastern Finland (UEF) with the terms in the 
accompanying file license.txt. Alexey Sholokhov, sholok@cs.uef.fi, 
Md Sahidullah, sahid@cs.uef.fi, Tomi H. Kinnunen, tkinnu@cs.uef.fi.
 
July 15, 2017, Joensuu, Finland 

================================================================================

This package contains a MATLAB demo of a speech activity detector (SAD) cited
above. The code has been completely written at UEF and should be self-contained;
however, it does call speech enhancement routines from Voicebox NOT included here 
(http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html).
So download Voicebox and add to your MATLAB path. 

As a part of the SAD we provide F0 detector (getf0s.c) along with its mex interface
written by Sadjad Siddiq while working at UEF (now with Square Enix <siddsadj@square-enix.com>)

The code has been tested only with MATLAB R2016a under Linux Mint release 18.1. 
While you are free to use and distribute the code, the authors take no reponsibility 
for any bugs or misuses of it -- use in on a "take it or leave it" basis.

The SAD has been specifically tailored for speaker verification experiments
on "typical" NIST data (mostly SRE 2008, 2010, 2012). These 'utterances' typically 
contain several minutes of data per recording. If you wanna use this for shorter data 
or other tasks, it probably requires fine-tuning of the parameters. Also, it is 
not suited for real-time processing but it takes maximum benefit from 
all the data in a given recording.

We provide additional code for MFCC extraction while other features can be used 
as well.

Though the study cited above focuses on Gaussian mixture model (GMM) based SAD, 
this package also includes codebook-based SAD: http://cs.uef.fi/pages/tkinnu/VQVAD/VQVAD.zip. 
That is, there are three approaches to define speech and non-speech models available 
in our package:
1. GMM, semi-supervised trainig
2. GMM, supervised training
3. VQ (codebook), supervised training

We are of course very happy to hear your feedback about possible bugs, problems 
of getting it running or possible weird results! Just drop us an email and we'll 
do our best to help you out :-)

================================================================================

If you use this package for published work, please cite the paper. 
Here is the BibTeX:

@article{ssgmm-sad-2017,
title = "Semi-supervised speech activity detection with an application to automatic speaker verification",
author = "Alexey Sholokhov and Md Sahidullah and Tomi Kinnunen",
journal = "Computer Speech & Language",
volume = "47",
number = "",
pages = "132 - 156",
year = "2018",
issn = "0885-2308",
doi = "http://dx.doi.org/10.1016/j.csl.2017.07.005",
url = "http://www.sciencedirect.com/science/article/pii/S088523081630328X",
}
