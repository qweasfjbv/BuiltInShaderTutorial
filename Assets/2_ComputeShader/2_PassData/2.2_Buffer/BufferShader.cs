﻿using UnityEngine;

namespace ShaderTutorial.ComputeSh._2
{
    public class BufferShader : MonoBehaviour
    {
        public ComputeShader shader;
        public Color clearColor;
        public Color circleColor;
        public int count;

        Renderer rend;
        RenderTexture outputTexture;

        int texResolution = 1024;
        int circlesHandle;
        int clearHandle;

        struct Circle
        {
            public Vector2 origin;
            public Vector2 velocity;
            public float radius;
        }

        Circle[] circleData;
        ComputeBuffer buffer;

		private void Start()
		{
            outputTexture = new RenderTexture(texResolution, texResolution, 0);
            outputTexture.enableRandomWrite = true;
            outputTexture.Create();
			
            rend = GetComponent<Renderer>();
            rend.enabled = true;

            InitData();

            InitShader();
		}

        private void InitData()
        {
			circlesHandle = shader.FindKernel("Circles");

            uint threadGroupSizeX;
            // [numthreads(x, y, z)] 값을 받아옴
            shader.GetKernelThreadGroupSizes(circlesHandle, out threadGroupSizeX, out _, out _);

            int total = (int)threadGroupSizeX * count;
            circleData = new Circle[total];

            float speed = 100;
            float halfSpeed = speed * 0.5f;
            float minRadius = 10.0f;
            float maxRadius = 30.0f;
            float radiusRange = maxRadius - minRadius;
             
            for(int i=0; i<total; i++)
            {
                Circle circle = circleData[i];
                circle.origin.x = Random.value * texResolution;
                circle.origin.y = Random.value * texResolution;
                circle.velocity.x = Random.value * speed - halfSpeed;
                circle.velocity.y = Random.value * speed - halfSpeed;
                circle.radius = Random.value * radiusRange + minRadius;
                circleData[i] = circle;
            }
		}

        private void InitShader()
        {
            clearHandle = shader.FindKernel("Clear");

            shader.SetInt("texResolution", texResolution);
            shader.SetVector("clearColor", clearColor);
            shader.SetVector("circleColor", circleColor);
            
            shader.SetTexture(circlesHandle, "Result", outputTexture);
            shader.SetTexture(clearHandle, "Result", outputTexture);

            int stride = (2 + 2 + 1) * sizeof(float);
            buffer = new ComputeBuffer(circleData.Length, stride);
            buffer.SetData(circleData);
            shader.SetBuffer(circlesHandle, "circlesBuffer", buffer);

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
            DispatchKernels(count);
		}


        // RenderTexture.Create, new ComputeBuffer 등은 GPU메모리 할당을 발생시킴
        // 따라서 명시적으로 해제해야함
        private void OnDestroy()
		{
			if (buffer != null)
			{
				buffer.Release();
				buffer = null;
			}

			if (outputTexture != null)
			{
				outputTexture.Release();
				outputTexture = null;
			}
		}
	}
}