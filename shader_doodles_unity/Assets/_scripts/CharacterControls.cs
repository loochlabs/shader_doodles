using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace shishi
{
    [ExecuteInEditMode]
    public class CharacterControls : MonoBehaviour
    {
        enum FootstepType
        {
            RIGHT = 0,
            LEFT
        }

        struct Footstep
        {
            public Vector3 pos;
            public FootstepType footstep;
            public float ttl;

            public float TTL{
                get { return ttl;}
                set { this.ttl = value; }
            }

            public Footstep(Vector3 pos, FootstepType footstep, float ttl)
            {
                this.pos = pos;
                this.footstep = footstep;
                this.ttl = ttl;
            }
        }


        [Range(0.01f, 1f)]
        public float speed = 1;
        [Range(0.01f, 1f)]
        public float distThreshold = 0.25f;
        [Range(0.02f, 5f)]
        public float distBetweenSteps = 1f;
        [Range(0.4f, 5f)]
        public float footstepTTL = 1f;

        private Camera cam;
        private Vector3 camOffset;
        private bool mouseReleased = false;
        private List<Footstep> footsteps = new List<Footstep>();
        private List<Vector4> footstepPositions = new List<Vector4>();
        private Vector4[] footstepsToShaderArray = new Vector4[16];
        private float distanceToNextStep = 0;

        private void Start()
        {
            cam = Camera.main;
            camOffset = transform.position - cam.transform.position;

            Shader.SetGlobalInt("_PositionCount", 0);
            Shader.SetGlobalVectorArray("_Positions", footstepsToShaderArray);
        }

        // Update is called once per frame
        void Update()
        {
            //cam.transform.position = transform.position - camOffset;

            if (Input.GetMouseButtonDown(0) && mouseReleased)
            {
                mouseReleased = false;
                Ray ray = cam.ScreenPointToRay(Input.mousePosition);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit))
                {
                    CreateStep(hit.point);
                    StartCoroutine(moveto(hit.point));
                }

            }
            else if (Input.GetMouseButtonUp(0) && !mouseReleased)
            {
                mouseReleased = true;
            }

            //UpdateFootsteps(Time.deltaTime);
            UpdateFootstepShader();
        }

        IEnumerator moveto(Vector3 target)
        {
            while (Vector3.Distance(target, transform.position) > distThreshold)
            {
                /*
                if(distanceToNextStep <= 0)
                {
                    distanceToNextStep = distBetweenSteps;
                    CreateStep(transform.position);
                }
                distanceToNextStep -= speed * Time.deltaTime;
                */

                Vector3 dir = (target - transform.position).normalized * speed * Time.deltaTime;
                dir += transform.position;
                transform.position = dir;
                if (Vector3.Distance(target, transform.position) > distThreshold) transform.position = dir;
                yield return null;
            }
        }

        private void CreateStep(Vector3 pos)
        {
            //capping footsteps at 64 for now until we find a cleaner way
            if(footsteps.Count > 16)
            {
                RemoveStep(footsteps[0]);
            }
            footsteps.Add(new Footstep(pos, FootstepType.RIGHT, footstepTTL));
            footstepPositions.Add(pos);
            Debug.Log("Footstep Counts: " + footsteps.Count);
        }

        private void RemoveStep(Footstep footstep)
        {
            footstepPositions.Remove(footstep.pos);
            footsteps.Remove(footstep);
        }

        private void UpdateFootsteps(float dt){
            foreach(var ft in footsteps){
                SubtractFootstepTTL(ft, dt);
                if(ft.TTL <= 0)
                {
                    RemoveStep(ft);
                }
            }
        }

        private void SubtractFootstepTTL(Footstep footstep, float dt)
        {
            footstep.TTL -= dt;
        }

        private void UpdateFootstepShader()
        {
            if (footstepPositions.Count <= 0) return;
            for(int i =0; i < footstepPositions.Count; i++)
            {
                footstepsToShaderArray[i] = footstepPositions[i];
            }
            Debug.Log("Footsteps : " + footstepPositions.Count);
            Shader.SetGlobalInt("_PositionCount", footstepPositions.Count);
            Shader.SetGlobalVectorArray("_Positions", footstepsToShaderArray);
        }
    }
}
