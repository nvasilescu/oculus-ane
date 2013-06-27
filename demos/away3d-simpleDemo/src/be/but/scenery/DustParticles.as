package be.but.scenery 
{
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.ParticleBillboardNode;
	import away3d.animators.nodes.ParticleFollowNode;
	import away3d.animators.nodes.ParticlePositionNode;
	import away3d.animators.nodes.ParticleVelocityNode;
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.ParticleGeometryHelper;
	import away3d.tools.utils.Bounds;
	import away3d.utils.Cast;
	import be.but.oculus.OculusSetup;
	import flash.display.BlendMode;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author 
	 */
	public class DustParticles extends Mesh
	{
		//particle image
		[Embed(source="/../embeds/dust.png")]
		private var ParticleImg:Class;
		
		private var _radius:Number = 10;
		private var _particleFollowNode:ParticleFollowNode;
		
		public function DustParticles(lightPicker:StaticLightPicker, particles:int = 600) 
		{
			//setup the particle material
			var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(ParticleImg));
			material.alphaBlending = true;
			//material.blendMode = BlendMode.ADD;
			
			//generate the particle geometry
			var plane:Geometry = new PlaneGeometry(0.1, 0.1, 1, 1, false, false);
			var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
			for (var i:int = 0; i < particles; i++)
			{
				geometrySet.push(plane);
			}
			var particleGeometry:Geometry = ParticleGeometryHelper.generateGeometry(geometrySet);
	
			
			//create the particle animation set
			var animationSet:ParticleAnimationSet = new ParticleAnimationSet(true, true, true);

			//add behaviors to the animationSet
			animationSet.addAnimation(new ParticleBillboardNode());
			animationSet.addAnimation(new ParticlePositionNode(ParticlePropertiesMode.LOCAL_STATIC));
			
			_particleFollowNode = new ParticleFollowNode();
			animationSet.addAnimation(_particleFollowNode);
			
			//set the initialiser function
			animationSet.initParticleFunc = initParticleParam;
			
			var animator_:ParticleAnimator = new ParticleAnimator(animationSet);
			
			super(particleGeometry, material);
			animator = animator_;

			
			
			animator_.start();
		}
		
		public function follow(object:ObjectContainer3D):void 
		{
			_particleFollowNode.getAnimationState(animator).followTarget = object;
			bounds.fromSphere(object.position, 20000);
		}

		/**
		 * Initialiser function for particle properties. It's invoked for every particle.
		 */
		private function initParticleParam(prop:ParticleProperties):void
		{
			prop.duration = 16;
			prop.startTime = prop.index * (prop.duration / prop.total);
			prop.delay = 0;
			//trace( "prop.duration : " + prop.duration );
			//trace( "prop.startTime : " + prop.startTime );
			
			var x:Number = getRandomPosWithinRadius();
			var y:Number = getRandomPosWithinRadius();
			var z:Number = getRandomPosWithinRadius();
			//trace( "z : " + z );
			var pos:Vector3D = new Vector3D(x, y, z);
			prop[ParticlePositionNode.POSITION_VECTOR3D] = pos;
		}
		
		private function getRandomPosWithinRadius():Number
		{
			return _radius - ((Math.random() * _radius) * 2);
		}
	}

}