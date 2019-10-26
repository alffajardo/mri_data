# Seed-Based Correlation Analysis

En este tutorial aprenderás dos formas de hacer un seed-based correlation analysis (SCA) ya sea a usando AFNI y FSL  o usando R. Como bien sabes el SCA es uno de los métodos más sencillos  de estimar la Conectividad funcional en el cual primero se extrae la serie temporal promedio de una región de interés y luego  se computa un mapa de correlación (pearson) de esa serie de tiempo con la del resto de los voxeles de la imagen funcional. 

**Para seguir este tutorial puedes usar los siguientes archivos:**

- ###### [NIFTI  4D preprocesado](https://drive.google.com/file/d/14Mx4MbFO2GjrMWvq4-CHX3HHbiN_A3jh/view?usp=sharing) (pronto existirá una sección sobre preprocesamiento de datos de  resting state)

  ![](https://github.com/alffajardo/mri_data/blob/master/tutorials/sca/func.gif)

- **[ NIFTI ROI binario](https://github.com/alffajardo/mri_data/blob/master/tutorials/sca/pcc_mask.nii.gz)** (Consulta como hacer un ROI binario [aquí](https://www.youtube.com/watch?v=fIu4tUjRfUE&t=9s))

  ![](https://github.com/alffajardo/mri_data/blob/master/tutorials/sca/pcc_mask.png)

  

 **Nota importante:** Aunque quizás parezca obvio, no está de más decir que tu NIFTI 4D y tu ROI deben tener las mismas dimensiones x y z y estar en el mismo espacio. En este caso ambas imágenes ya se encuentran en el espacio del atlas MNI152

  
  
  ## OPCIÓN 1: USANDO FSL Y AFNI  DESDE LA TERMINAL

  para mayores facilidades puedes descargar el script **[rmap_afni.sh](https://github.com/alffajardo/mri_data/blob/master/tutorials/sca/rmap_afni.sh)**. Una vez que le hayas dado permisos de ejecución al archivo simplemente necesitas correrlo de la siguiente manera:

```rmap_afni.sh <archivo NIFTI preprocesado> < ROI binario> <nombre del output> ```
  
  ejemplo: 

  ```./rmap_afni.sh sub-001_bandassed_denoised_warp_FWHM4.nii.gz pcc_mask.nii.gz sub-001_pcc```

  **A continuación explicaremos en detalle que es lo que hace este script:**
  
  1.  Extraer la serie de tiempo promedio de tu funcional usando el ROI:
  
```fslmeants -i sub-001_bandassed_denoised_warp_FWHM4.nii.gz -m pcc_mask.nii.gz -o pcc.ts```

Si realizaste bien este paso, al intrducir en la terminal el comando `head pcc.ts`  deberías ver lo siguiente:
  
 ``` -3.744489014 
    1.972393204 
    10.74178089 
    14.54784234 
    8.430280266
   -5.448772119 
   -19.30749452 
   -25.47799781 
   -21.67057823 
   -11.75656644
```
2. Obtener el mapa de correlación con AFNI

```3dTcorr1D -prefix sub-001_pcc_corrmap.nii.gz sub-001_bandassed_denoised_warp_FWHM4.nii.gz pcc.ts```

Puedes visualizar el mapa de correlación con el visor de tu preferencia. para visualizarlo con fsleyes escribe:

```fsleyes -std sub-001_pcc_corrmap.nii.gz -dr 0.3 0.8   -cm red-yellow```


**Si hiciste todo bien deberías ver algo como en la siguiente imagen:**

![](https://github.com/alffajardo/mri_data/blob/master/tutorials/sca/sub-001_pcc_corrmap.png)

### Como podrás observar hemos obtenido un patrón muy conocido en la literatura. ¡¡Así es!! ¡¡Se trata de la ***Default Mode Network***!! 
