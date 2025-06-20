using System.Linq;
using System.Runtime.Serialization.Formatters;
using UnityEngine;

namespace ShaderTutorial.ComputeSh._2
{
    public class MeshDeform : MonoBehaviour
    {
        public ComputeShader shader;
        [Range(0.5f, 2.0f)]
        public float radius;

        public struct Vertex
        {
            public Vector3 position;
            public Vector3 normal;

            public Vertex(Vector3 p, Vector3 n) { position = p; normal = n; }
        }

        int kernelHandle;
        Mesh mesh;

        Vertex[] vertexArray;       // Vertex저장
        Vertex[] initialArray;      // Model 포지션 저장
        ComputeBuffer vertexBuffer;
        ComputeBuffer initialBuffer;

		private void Start()
		{
            if (InitData())
            {
                InitShader();
            }
		}
        bool InitData()
        {
            kernelHandle = shader.FindKernel("MeshDeform");

            MeshFilter mf = GetComponent<MeshFilter>();
            if (mf == null)
            {
                Debug.Log("No MeshFilder found");
                return false;
            }

            InitVertexArrays(mf.mesh);
            InitGPUBuffers();

            mesh = mf.mesh;
            return true;
        }

        void InitShader()
        {
            shader.SetFloat("radius", radius);
        }

        void InitVertexArrays(Mesh mesh)
        {
            vertexArray = new Vertex[mesh.vertices.Count()];
            initialArray = new Vertex[mesh.vertices.Count()];

            for(int i=0; i<vertexArray.Length; i++)
            {
                Vertex v1 = new Vertex(mesh.vertices[i], mesh.normals[i]);
                vertexArray[i] = v1;
                Vertex v2 = new Vertex(mesh.vertices[i], mesh.normals[i]);
                initialArray[i] = v2;
            }
        }

        void InitGPUBuffers()
        {
            vertexBuffer = new ComputeBuffer(vertexArray.Length, sizeof(float) * 6);
            vertexBuffer.SetData(vertexArray);
			initialBuffer = new ComputeBuffer(initialArray.Length, sizeof(float) * 6);
			initialBuffer.SetData(initialArray);

            shader.SetBuffer(kernelHandle, "vertexBuffer", vertexBuffer);
            shader.SetBuffer(kernelHandle, "initialBuffer", initialBuffer);
		}

        void GetVerticesFromGPU()
        {
            vertexBuffer.GetData(vertexArray);
            Vector3[] vertices = new Vector3[vertexArray.Length];
            Vector3[] normals = new Vector3[vertexArray.Length];

            for (int i = 0; i < vertexArray.Length; i++)
            {
                vertices[i] = vertexArray[i].position;
                normals[i] = vertexArray[i].normal;
            }

            mesh.vertices = vertices;
            mesh.normals = normals;
        }

		private void Update()
		{
            if (shader)
            {
                shader.SetFloat("radius", radius);
                float delta = (Mathf.Sin(Time.time) + 1) / 2;
                shader.SetFloat("delta", delta);
                shader.Dispatch(kernelHandle, vertexArray.Length, 1, 1);

                GetVerticesFromGPU();
            }
		}
		private void OnDestroy()
		{
			vertexBuffer.Dispose();
            initialBuffer.Dispose();
		}
	}
}
