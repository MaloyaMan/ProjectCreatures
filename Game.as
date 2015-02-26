package  
{
	import starling.text.TextField;
	import starling.animation.Juggler;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.display.MovieClip;
	
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.Color;
	
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.events.EnterFrameEvent;
	import starling.animation.Juggler;
	
	import starling.core.Starling;
	
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Romain Quessada
	 */
	public class Game extends Sprite
	{
		/*[Embed(source = "../resource/Montagne.jpeg")]
		private static const Background:Class;*/
		
		[Embed(source = "../resource/Montagne_mobile.png")]
		private static const Montagne:Class;
		
		[Embed(source = "../resource/Ciel_mobile.png")]
		private static const Ciel:Class;
		
		[Embed(source = "../resource/Colline1.png")]
		private static const Colline:Class;
		
		[Embed(source = "../resource/Prairie.png")]
		private static const Prairie:Class;
		
		[Embed(source = "../resource/herbe_mobile.png")]
		private static const Herbe:Class;
		
		[Embed(source = "../resource/soleil.png")]
		private static const Soleil:Class;
		
		[Embed(source = "../resource/lune.png")]
		private static const Lune:Class;
		
		[Embed(source = "../resource/aube.png")]
		private static const Aube:Class;
		
		[Embed(source = "../resource/cycle_soleil_lune.xml", mimeType="application/octet-stream")]
		private static const XMLCycleSoleilLuneC:Class;
		
		public var spriteHerb:Sprite = new Sprite();
		public var spritePrairie:Sprite = new Sprite();
		public var spriteColline:Sprite = new Sprite();
		public var spriteMountain:Sprite = new Sprite();
		public var spriteBg:Sprite = new Sprite();
		public var sprite:Sprite = new Sprite();
		
		public var posDeb:int;
		public var posFin:int;
		public var translation:int
		
		public var _date:Date;
		
		public var quadDebut:Quad = new Quad(2, 2, Color.RED);
		public var quadFin:Quad = new Quad(2, 2, Color.RED);
		
		// Embed the Atlas XML
		[Embed(source="../resource/arbres/arbres.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="../resource/arbres/arbres.png")]
		public static const AtlasTexture:Class;
		 
		// create atlas
		var texture:Texture = Texture.fromBitmap(new AtlasTexture());
		var xml:XML = XML(new AtlasXml());
		var atlas:TextureAtlas = new TextureAtlas(texture, xml);
		 
		//XML
		var XMLCycleSoleilLune:XML = XML(new XMLCycleSoleilLuneC());

		//astres
		var soleil:Image = Image.fromBitmap(new Soleil());
		var lune:Image = Image.fromBitmap(new Lune());
		
		public function Game() 
		{
			/* Gestion du temps - refresh 2 scds*/
			/*var delayedCall:DelayedCall = new DelayedCall(method, 2.0);
			delayedCall.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(delayedCall);*/
			
			/* Animation */
			// create movie clip
			var movie:MovieClip = new MovieClip(atlas.getTextures("arbre"), 3);
			// important: add movie to juggler
			Starling.juggler.add(movie);
			// control playback
			movie.play();
			
			var ciel:Image = Image.fromBitmap(new Ciel());
			var colline:Image = Image.fromBitmap(new Colline());
			var colline2:Image = Image.fromBitmap(new Colline());
			var prairie:Image = Image.fromBitmap(new Prairie());
			var prairie2:Image = Image.fromBitmap(new Prairie());
			var herb:Image = Image.fromBitmap(new Herbe());
			var herb2:Image = Image.fromBitmap(new Herbe());
			var mountain:Image = Image.fromBitmap(new Montagne());

			
			//var bgd:Image = Image.fromBitmap(new Bckgrnd());

			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			translation = 0;
			
			/* Création des filtres */
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			var blur:BlurFilter = new BlurFilter();
			
			/* Spécification des filtres */
			filter.adjustSaturation( -0.5);
			spriteHerb.filter = filter;
			//sprite.filter = blur;
			//bgd.color = Color.RED;
			
			/*ciel.color =  Color.AQUA;
			mountain.color = Color.BLUE;*/
			
			spriteBg.addChild(ciel);
			spriteMountain.addChild(mountain);
			spriteHerb.addChild(herb);
			herb2.x = herb2.x + herb2.width;
			spriteHerb.addChild(herb2);
			spriteColline.addChild(colline);
			colline2.x = colline2.x + colline2.width;
			spriteColline.addChild(colline2);
			spritePrairie.addChild(prairie);
			prairie2.x = prairie2.x + prairie2.width;
			spritePrairie.addChild(prairie2);
			
			/* Positionnement de l'animation de l'arbre */
			movie.y = movie.y + 20;
			spritePrairie.addChild(movie);
			
			spriteBg.addChild(soleil);
			spriteBg.addChild(lune);
			
			sprite.addChild(spriteBg);
			sprite.addChild(spriteMountain);
			sprite.addChild(spriteColline);
			sprite.addChild(spritePrairie);
			sprite.addChild(spriteHerb);
			addChild(sprite);
			
			
			posDeb = spriteHerb.x;
			posFin = spriteHerb.x + spriteHerb.width;
			
			quadDebut.x = spriteHerb.x;
			quadFin.x = spriteHerb.x + spriteHerb.width;
			addChild(quadDebut);
			addChild(quadFin);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			/* Fonction de gestion du multi-touch lié au listener précédent*/
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			//Gestion de deux doigts seulement
			if (touches.length == 2)
			{
				var touch1:Touch = touches[0];
				var touch2:Touch = touches[1];
				var currentPos:Point  = touch1.getLocation(this);
				var previousPos:Point = touch1.getPreviousLocation(this);
				
				translation = currentPos.x - previousPos.x;
			
				if ((posDeb <= 0) && (translation > 0) || (posFin >= 320) && (translation < 0))
			{
				quadDebut.x = quadDebut.x + translation;
				quadFin.x = quadFin.x + translation;
				
				spriteHerb.x = spriteHerb.x + translation;
				spritePrairie.x = spritePrairie.x + (translation * 0.6);
				spriteColline.x = spriteColline.x + (translation * 0.3);
				spriteMountain.x = spriteMountain.x + (translation * 0.050);
			}	
				trace("-------- OnTouch --------");
				trace("Heure: " + _date.getHours());
				trace("posDeb: " + posDeb);
				trace("posFin: " + posFin);
				trace("spriteHerb.x: " + spriteHerb.x);
				trace("spriteMountain.x: " + spriteMountain.x);
				trace("translation: " + translation);
				trace("------------------------");
			}
		}
		
		/* Evènement rafraîchissement de l'écran */
		private function onEnterFrame(event:EnterFrameEvent):void
		{	
			CycleJourNuit();
			
			posDeb = spriteHerb.x;
			posFin = spriteHerb.x + spriteHerb.width;
			
			/* Dépassement du bord gauche */
			if ((posDeb > 0) && (translation > 0)) 
			{
				translation = 0;	
				//Recalage du paysage si débordement
				spriteHerb.x = 0;
				spritePrairie.x = 0;
				spriteColline.x = 0;
				spriteMountain.x = 0;
			}
			
			/* Dépassement du bord droit */
			if ((posFin < 320) && (translation < 0))
			{
				translation = 0;	
				//Recalage du paysage si débordement
				spriteHerb.x = 320 - spriteHerb.width;
				spritePrairie.x = 320 - spritePrairie.width;
				spriteColline.x = 320 - spriteColline.width;
				spriteMountain.x = 320 - spriteMountain.width;
			}
			
		}
		
		//Retourne le
		// [0] : x courant de l'astre
		// [1] : y courant de l'astre
		// [2] : Astre
		public function positionAstre(heure:Number,debutPlage:XMLList,finPlage:XMLList, astre:String):Array
		{
			var coeffDroite:Array = equationDroite(debutPlage.x, debutPlage.y, finPlage.x, finPlage.y);
			var xCourant:Number = conversionHeurePixel(heure, debutPlage.t, finPlage.t, debutPlage.x, finPlage.x);
			var yCourant:Number = coeffDroite[0] * xCourant + coeffDroite[1];
			
			return new Array(xCourant, yCourant, astre);
		}
		
		public function getHourMinute ():Number
		{
			_date = new Date();
			return(_date.getHours() + (_date.getMinutes() / 60));
		}	
		
		public function equationDroite (xd:int,yd:int,xf:int,yf:int):Array
		{
			var a, b : Number;
			a = (yf - yd) / (xf - xd);
			b = yd - a * xd ;
			
			return (new Array(a, b));
		}
		
		public function conversionHeurePixel (tCourant:Number, tDebut:Number, tFin:Number, xDebut:Number, xFin:Number ):Number
		{
			return (tCourant - tDebut) * ((xFin - xDebut) / (tFin - tDebut)) + xDebut;
		}
		
		//Fonction globale
		// - Gestion de la position de l'astre
		// - Gestion de l'aube, crépuscule, jour, nuit
		public function CycleJourNuit() {
			
			var heure:Number;
			
			heure = getHourMinute();

			var plage:XMLList = XMLCycleSoleilLune.ete.plage.(t_debut.t <= heure);
			var debutPlageAstre:XMLList = plage[plage.length() - 1].t_debut;
			var finPlageAstre:XMLList = plage[plage.length() - 1].t_fin;
			var astre:String = plage[plage.length() - 1].astre;
			
			var astreRetour:Array = positionAstre(heure, debutPlageAstre, finPlageAstre, astre);
			
			if (astreRetour[2] == "lune")
			{
				lune.x = astreRetour[0] - (lune.width/2); //(soustraction pour replacer l'origine de l'image à son milieu)
				lune.y = astreRetour[1] - (lune.height/2);
				lune.visible = true;
				soleil.visible = false;
			}
			else 
			{
				soleil.x = astreRetour[0] - (soleil.width/2);
				soleil.y = astreRetour[1] - (soleil.height/2);
				soleil.visible = true;
				lune.visible = false;				
			}
			
			//var debutPlageEtape:XMLList = rechercheDebutTransition
			//var finPlageEtape:XMLList = rechercheFinTransition
			//calculAlpha()
			//positionAlpha();
		}
		
		//Renvoie la liste XML contenant la première transition (aube, jour...)
		public function rechercheDebutTransition():XMLList
		{
			//TODO
			return null;
		}
		
		//Renvoie la liste XML contenant la dernière transition
		public function rechercheFinTransition():XMLList
		{
			//TODO
			return null;
		}
		
		//Calcul de l'alpha de l'astre en cours
		public function calculAlpha():Number
		{
			//TODO
			//heureFinTransition - heureDebutTransition / heureCourante - heureDebutTransition (*100)
			return null;
		}
		
		//Positionne tous les alphas correspondants pour chaque background
		public function positionAlpha():void
		{
			//TODO
			//Tableau contenant Aube, Jour, Crepuscule, Nuit
			//Application des alphas en fonction de l'étape courante et en suivant le chaînage du tableau
		}
	}

}