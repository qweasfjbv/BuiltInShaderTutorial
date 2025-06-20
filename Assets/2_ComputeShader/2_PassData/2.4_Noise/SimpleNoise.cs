using UnityEngine;

namespace ShaderTutorial.ComputeSh._2
{
    public class SimpleNoise : MonoBehaviour
    {
        public ComputeShader shader;
        public int texResolution = 256;

        Renderer rend;
        RenderTexture outputTexture;

        int kernelHandle;

		private void Start()
		{
            outputTexture = new RenderTexture(texResolution, texResolution, 0);
            outputTexture.enableRandomWrite = true;
            outputTexture.Create();

            rend = GetComponent<Renderer>();    
            rend.enabled = true;

            InitShader();
		}

        private void InitShader()
        {
            kernelHandle = shader.FindKernel("SimpleNoise");
			shader.SetInt("texResolution", texResolution);

            shader.SetTexture(kernelHandle, "Result", outputTexture);
			rend.material.SetTexture("_MainTex", outputTexture);
        }

		private void Update()
		{
            shader.SetFloat("time", Time.time);
            shader.Dispatch(kernelHandle, texResolution / 8, texResolution / 8, 1);
		}
	}
}