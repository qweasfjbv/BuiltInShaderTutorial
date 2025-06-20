using UnityEngine;

namespace ShaderTutorial.ComputeSh._2
{
    public class PassData : MonoBehaviour
    {
        public ComputeShader shader;
        public Color clearColor;
        public Color circleColor;

        Renderer rend;
        RenderTexture outputTexture;

        int circlesHandle;
        int clearHandle;
        int texResolution = 256;

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
            circlesHandle = shader.FindKernel("Circles");
            clearHandle = shader.FindKernel("Clear");

            shader.SetInt("texResolution", texResolution);
            shader.SetVector("clearColor", clearColor);
            shader.SetVector("circleColor", circleColor);
            
            shader.SetTexture(circlesHandle, "Result", outputTexture);
            shader.SetTexture(clearHandle, "Result", outputTexture);

            rend.material.SetTexture("_MainTex", outputTexture);
        }

        private void DispatchKernels(int count)
        {
            shader.Dispatch(clearHandle, texResolution / 8, texResolution / 8, 1);
            shader.SetFloat("time", Time.time);
            shader.Dispatch(circlesHandle, count, 1, 1);
        }

		private void Update()
		{
            DispatchKernels(10);
		}

	}
}