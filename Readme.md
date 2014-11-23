This project has been done as a part of Image Processing course for Spring 2013 Semester at IIT Delhi.

Supervisor: Dr. Ranjan Bose

Author: T Veeranjaneya Ashok http://github.com/tvashok

Automatic car number plate detection using morphological image processing

Image processing method which allows detecting a car number plate on the image presenting a car entering the supervised area. The method is intended to be a first part of the identification process which consists also of a second part - the recognition of detected characters. Automatic car number plates’ detection is 
performed by means of mathematical morphology. It makes use of an intelligent filtering of the input image based on a set of filters removing unnecessary image elements, but preserving the position and shape of characters of the car number plate.

Number plates: old (white letters on black background) and new ones (black letters on white background). 
The detection algorithm makes use of two properties of car number plate: that car number plate is an object with white (or black) objects on the black (white) background and that the position of the plate is such that its edges are parallel to the image x and y axes. The operations in all the processing steps require some 
parameters (e.g. size of opening, etc.). Their choice depends on the size of the number plate on the input 
image. This cannot by fully automated since both the resolution of the input image and size of number plate can vary. On the other hand in the real identification system, a position of the camera is fixed, as well as a position of a car in relation to the camera. Consequently some parameters can be easily introduced by the human operator once for the particular installation (a camera calibration step). Considering that the size of characters on the image, its thickness as well as the  x and  y-sizes of the number plate depend one on another, it is sufficient when just one of them is introduced as the algorithm input parameter. In the experiments described in this paper the parameter chosen was a height h of the number plate in pixels. 


The processing scheme was designed to achieve the following goals: 

1) Detection of both old (white letters on black background) and new (black letters on white background) plates. 
2) Lack of sensitivity to various lighting conditions, ability to process image taken indoors and outdoors 
3) Detection of plates of different sizes inside a certain interval – ability to detect plates of cars closer and more distant from the camera 

Algorithm
---------

The algorithm consists of five steps described in the following sections.

Step 1 - contrast enhancement

Car number plate is characterized by high contrast. Black letters on the white background (or reversely) is 
theoretically the highest possible one. Due to variable lighting conditions (especially for pictures taken indoors) this contrast is often not as high as necessary. To improve it, the top-hat contrast enhancement is applied. Its size has been set to h/2, where his a parameter introduced in the previous section.

Step 2 - background cleaning 

Second step is a crucial one. It aims at removing the most of unnecessary areas on the image. To reach this goal a combination of two top-hats (white and black) by reconstruction is applied. White top-hat detects old plates, while the black one - new plates. Since the method has to detect both kinds of plates without any a-priori knowledge, it must - for every image – attempting to detect both  kind of plates, and combine later the results.

This combination is done by means of a supremum of both top-hats. The important requirement is a preservation of shapes of the letters on the top-hat images, so that they can be correctly recognized in further steps of treatment. This feature was the motivation of applying the reconstruction filters in both top-hats. The size of opening and closing by reconstruction being part of top-hats has been set  to  h/5.

Step 3 - plate area detection 

The result of combination of two top-hats contains not only letters of number plate but also a lot of other unwanted image elements. In order to detect the proper area, the directional filtering is then applied. The choice of such filters was motivated by the fact that main axes of car number plates are parallel to the main axes of image coordinate system. Due to a short distance between consecutive characters some deviations from the parallel position are allowed and – if they are not too big (not bigger that approximately 10 degrees) – they don’t disturb the detection process.

The process has two phases: rough detection and filtering. To detect roughly where the plate is located, the directional horizontal closing is performed. This operation makes use of the fact that plate characters consists of lighter areas close one to another aligned along the x image axis. The directional closing joins the characters and forms the rough area of the plate. The size of closing was set to 4h. A result is shown on fig. The second phase aims at removing the unnecessary areas, which doesn’t belong to the plate area. This is done using two directional openings: vertical (size h/2) followed by horizontal (size 2h). A result of this operation is shown on fig.The resulting image contains several light areas. The area of number plate is noticeably lighter than the other light fragments. To binarize it, double threshold technique is used. Such a choice was due to the fact that for some images simple thresholding was too sensitive to the choice of threshold level. The values of double threshold parameters were following:  a=m/2, b=m-1, c=d=255, where m is a maximum value of image pixel just before binarization and 255is maximal possible value of image pixel.

Step 4 - extraction of characters

The last step of treatment consists in extraction of single characters from the number plate. In the first phase there must be detected what kind of plate – old or new – is currently being processed. To do this, two images –results of top-hats from computed in the second step (background removal) are analysed. The volume (sum of pixel values) of areas covered by a plate area is computed on both images. The image where letters are visible have obviously higher volume and this image is chosen for further processing. The main operation of this processing is thresholding with a threshold values equal to a=m/3, b=255where m is a maximum value of image just before binarization. The result of this binarization is then intersected with the number plate area detected previously. Results of processing are shown

Step 5: Optical Character Recognition

Optical character recognition, usually abbreviated to OCR, is the mechanical or electronic conversion of scanned images of handwritten, typewritten or printed text into machine-encoded text. It is widely used as a form of data entry from some sort of original paper data source, whether documents, sales receipts, mail, or any number of printed records. It is a common method of digitizing printed texts so that they can be electronically searched, stored more compactly, displayed on-line, and used in machine processes such as machine translation, text-to-speech and text mining. OCR is a field of research in pattern recognition, artificial intelligence and computer vision. Early versions needed to be programmed with images of each character, and worked on one font at a time. "Intelligent" systems with a high degree of recognition accuracy for most fonts are now common. Some systems are capable of reproducing formatted output that closely approximates the original scanned page including images, columns and other non-textual components.

System Requirements
-------------------
MATLAB with Image Processing Toolbox installed


Running Code
------------

a) Add the path of the extract.m/extract2.m file to that of the MATLAB
b) From the command window of Matlab, call the function in the following manner
	>> extract2('Demo_d.jpg',4);	
   Here the number 4 indicates the file Demo_d.jpg, Similarly enter 1 for Demo_a.jpg, 2 for Demo_b.jpg and 3 for Demo_c.jpg. These numbers make the code to choose binary thresholding value according to the image, automated version of the code will be updated in the future versions. 
   Similarly, if you want to run extract.m,
	>> extract('Demo_d.jpg');
   This code is meant especially for the image Demo_d.jpg for better number plate extraction. Users can choose one of the codes according to the quality of extraction

Contribute
----------
Source Code: https://github.com/tvashok/number-plate-extraction/

License
-------
This project is licensed under the terms of the MIT license. See License.txt for details
	
