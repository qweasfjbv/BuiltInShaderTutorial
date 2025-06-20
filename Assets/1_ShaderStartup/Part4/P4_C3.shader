Shader "Custom/P4/P4_C3"
{
    // Inspector 창에서 조작 가능한 프로퍼티 선언
    Properties
    {
        // Property의 기본 구조
        // _Name ("display name", Type) = default { options }

        // Float
        _TestRanae ("TestRange", Range(-1, 1)) = 0
        _TestFloat ("TestFloat", Float) = 0.5
        _TestInt ("TestInt", int) = 1

        // Float4
        _TestColor ("TestColor", Color) = (1, 1, 1, 1)
        _TestVector("TestVector", Vector) = (1, 1, 1, 1)

        // Other sampler
        _TestTexture ("TestTexture", 2D) = "white" {}
        _TestCube ("TestCube", Cube) = "_Skybox" {}
        _TestRect ("TestRect", Rect) = "0,0,1,1" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Snippet
        // 쉐이더의 조명 계산 설정, 함수 설정 등 ...
        #pragma surface surf Standard fullforwardshadows

        // Structure
        // Input : 엔진으로부터 받아와야 할 데이터
        struct Input {
            float2 uv_MainTex ;
            float4 color : COLOR ;
        };

        // 프로퍼티는 _Name와 같은 이름으로 선언하여 사용가능
        float _TestFloat;

        // Surface 함수
        // 색상, 이미지가 출력되는 부분
        void surf(Input IN, inout SurfaceOutputStandard o) {
  
        }

        ENDCG
    }
    FallBack "Diffuse"
}
