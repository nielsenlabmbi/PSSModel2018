# PSSModel2018
Instructions for running PSS cascade model on MATLAB®:


General description of files:


ModelFunction: 
Matlab function that runs a subset of model instances (subset determined by variable BigJobID) and computes correlation and mean square error between each of these instances and the data for each neuron in the file “modelData”.  The model instances are calculated using premade V1 responses stored in a folder called “V1RespFiles”. This code then computes the PSS input integration and non-linearity stages of the model but not the contrast or V1 motion energy mechanisms which are computed by the code in the files under the “For making V1 Files” folder. It outputs a mat file called Corr_X where X is the value of BigJobID containing the following:
-	A 2D matrix called BigAllignment that contains the alignment (in terms of orientation) between each neuron (in the second dimension) and each model instance (in the first dimension) that minimized the square error. This is the alignment used to calculate the values on BirCorr and BigError
-	A 2D matrix called BigCorr that contains the correlation values for each neuron (in the second dimension) for each model instance (in the first dimension).
-	A 2D matrix called BigError that contains the mean square error values for each neuron (in the second dimension) for each model instance (in the first dimension).
This function can be used to distribute the analyzes of different instances of the model across cores or computers to increase the speed of the model fitting.

ModelFunctionSh:
Same as model function with an added step to shuffle the neuron data across stimuli before fitting the model. 

CreateAllCorr:
Function that merges all resulting Corr_X files form ModelFunction into 1 file containing correlation error and alignment data for each neuron for all model instances.

getParamValues:
This function takes the ID of a model instance and returns the values of the different parameters of the model for that instance.


Files in folder “For making V1 Files”:


Example3DGrtStim:
This file contains a 3D (X,Y,Time) matrix for luminance values across space and time for a 50% contrast drifting grating. These matrices represent the stimuli that will be run through the model.

LGNRF:
This file contains a 2D (X,Y) matrix that represents the LGN receptive field that was used to compute LGN responses to the stimuli before contrast non-linearities.

LGNConvComponents:
This script uses the LGN receptive field saved in “LGNRF” to convolve 16 50% contrast drifting grating stimuli (saved in a file called “3DGrtStim” where stimuli are saved in matrices like that found in Example3DGrtStim). The LGN receptive field is centered on each pixel of each frame of the stimuli for each convolution resulting in a 3D matrix of LGN responses of the same size as the stimuli matrices. It outputs a file named conv3DGrtStim with the computed LGN responses to 50% drifting grating stimuli.

MakeV1RF:
This codes creates two simple V1 neuron receptive fields in quadrature as a 3D (X,Y,Time) matrix that will be used to compute simple cell responses. It saved them in “V1RF” to be used by “v1ResponsesFileMaker”.

v1ResponsesFileMaker:
First, this code uses the convolved 3D drifting grating stimuli representing LGN responses to make plaid stimuli LGN responses. Note that it is indifferent to first convolve the 3D grating stimuli with LGN receptive field to get grating LGN responses and then summing them to get a plaid LGN responses or to first make the plaid stimuli and then convolve these with LGN receptive field to get plaid LGN responses. This is due to the distributive property of the convolution function (conv(a + b) = conv(a) + conv(b)). Plaid stimuli responses are made by combining 2 grating stimuli responses with 4 different phase differences (similar to how the plaid stimuli are presented in our experiments).
Then, the resulting plaid LGN responses are transformed using a contrast non-linearity. The non-linearity is applied to both ON (represented as positive numbers in the LGN responses matrices) and OFF responses (represented as negative numbers).
The resulting LGN responses are then convolved with the 2 simple V1 receptive fields in quadrature to get a single V1 response value for each simple cell for each stimulus. The two simple cell responses are then combined as a motion energy mechanism to compute a complex V1 response for each stimulus. Responses of the complex V1 response can vary depending on the phase difference of the two grating stimuli composing the plaid. To account for this the V1 complex responses across different phase differences of the same plaid stimuli are averaged to get one final V1 response for each plaid stimulus. The complex V1 responses to different plaid stimuli are saved in a 2D (16x16) matrix with the drifting direction of each component grating in each dimension of the matrix. Note that in this format the response to each plaid stimuli is represented twice (V1Resp(1,2) = V1Resp(2,1)). 
This process is repeated for different values of the two variables that define the contrast response non-linearity step. The V1 responses corresponding to each instance of the contrast response function is saved in a file named V1Resp_X where X is the ID of the particular instance.


Instructions to run the model:


1 – Preparing data:
Responses of each neuron to be modeled should be saved as a 16x16 matrix where each dimension represents the drifting direction of the component grating making the stimuli. Values in the diagonal of this matrix should be responses of the neuron to 100% contrast drifting gratings (sum of two 50% drifting gratings moving in the same direction). Data from all neurons to be fitted should then be combined to make a Data cell structure where each cell contains the 16x16 matrix of each neuron responses. The Data cell structure should then be saved under a file named “modelData.mat”.

2 – Preparing V1 response files:
To reduce the time needed to run the model fits, it is useful to pre compute V1 response files for all the instances corresponding to the contrast response non-linearity step. To do this follow this steps:
A – file called “3DGrtStim.mat” needs to be created containing 3D matrices corresponding to luminance values of drifting grating stimuli moving in 16 different directions in a similar manner as the one saved under “Example3DGrtStim.mat”. 
B – Run “MakeV1RF.m” to generate the “V1RF.mat” file containing the two simple V1 receptive fields in quadrature.
C – Make a folder called V1RespFiles on the model folder and run “v1ResponsesFileMaker.m” for ID values 0 to 99 (100 instances of the contrast response function).
D – Move the V1RespFiles folder containing the V1 response files to the folder where “modelFunction.m” is so the function can find the files.

3 – Run model fits:
Create a folder in the model directory called “CorrFiles”. Then run “modelFunction.m” for BigJobID value 0 to 199. This will run 1,000,000 instances of the model and save the correlation and error values in 200 files in the CorrFiles folder.

4 – Merge Corr_X files:
Run “CreateAllCorr.m”. This function will merge all the Corr_X files creating an “AllCorr.mat” file containing correlation and error values for the fitting of the 1,000,000 model instances to each of the neurons.

5 – Get best model fit for each neuron:
Open the resulting AllCorr file. Find the model ID (position in the first dimension of the 2D matrix) that corresponds to the minimum mean square error of each neuron. This will be the model ID of your best fit for each neuron to the model. You can use the following line of code:
[Error IDs] = min(AllError,[],1);
You can use this IDs to find the corresponding correlation values in the matrix AllCorr. 

6 – Find the values of model variables for each neuron.
You can now use the function “getParamValues.m” to input the model IDs for the model fits of each neuron. This function will return the values of each model variable as follows:
[MtNL,C50,N,W,WI,I,ContrastSat,ExcW,InhW] = getParamValues(IDs);
Where MtnL: PSS threshold values. C50: the C50 variable of the contrast response function. N: the N variable of the contrast response function. W: The k of the excitatory weights function. WI: The k of the inhibitory weights function. I: The inhibition strength variable. 


Utilities:


ModelFunctionOneInstance:
This function received a model ID and outputs the resulting 16x16 PSS responses for that model instance. It can be useful to compare measured to modeled neuron responses.
