using UnityEngine;

namespace ShaderTutorial.ComputeSh._1
{
	public class SolidColor : MonoBehaviour
	{
		public ComputeShader shader;
		private RenderTexture outputTexture;
		private Renderer rend;

		private int kernelHandle;
		private int texResolution = 256;
		private string kernelName = "Rect";

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
			kernelHandle = shader.FindKernel(kernelName);
			shader.SetInt("texResolution", texResolution);

			shader.SetTexture(kernelHandle, "Result", outputTexture);

			rend.material.SetTexture("_MainTex", outputTexture);

			DispatchShader(texResolution / 8, texResolution / 8);
		}

		private void DispatchShader(int x, int y)
		{
			shader.Dispatch(kernelHandle, x, y, 1);
		}
	}
}