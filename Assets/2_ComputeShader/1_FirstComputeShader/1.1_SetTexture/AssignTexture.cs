using UnityEngine;

namespace ShaderTutorial.ComputeSh._1
{
    public class AssignTexture : MonoBehaviour
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
            kernelHandle = shader.FindKernel("CSMain");
            shader.SetTexture(kernelHandle, "Result", outputTexture);
            rend.material.SetTexture("_MainTex", outputTexture);

            DispatchShader(texResolution / 16, texResolution / 16);
        }

        private void DispatchShader(int x, int y)
        {
            // xy1 만큼의 group을 호출
            // -> texResolution/16 : 화면의 1/4만 계산됨
            // -> texResolution/8 : 화면 전체가 계산됨
            shader.Dispatch(kernelHandle, x, y, 1);
        }

		private void Update()
		{
            if (Input.GetKeyUp(KeyCode.U))
            {
                DispatchShader(texResolution / 8, texResolution / 8);
            }
		}
	}
}