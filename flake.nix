{
   description="Nixos niri-Noctalia";
   
   nixConfig = {
     extra-substituters = [ "https://niri.cachix.org" ];
     extra-trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
   };
   inputs = {
      nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
     
      home-manager = {
	  url = "github:nix-community/home-manager";
	  inputs.nixpkgs.follows = "nixpkgs";
      };

      noctalia = {
	  url = "github:noctalia-dev/noctalia-shell";
	  inputs.nixpkgs.follows = "nixpkgs";
      };

      niri = {
          url = "github:sodiboo/niri-flake";
	  inputs.nixpkgs.follows = "nixpkgs";
      };

      nixvim = {
          url = "github:nix-community/nixvim";
          inputs.nixpkgs.follows = "nixpkgs";
      };

      helium = {
          url = "github:schembriaiden/helium-browser-nix-flake";
          inputs.nixpkgs.follows = "nixpkgs";
      };
   };
	
    outputs = { self, nixpkgs, home-manager, noctalia, niri, nixvim, helium, ... }@inputs: {
      nixosConfigurations = {
         desktop = nixpkgs.lib.nixosSystem {
           system = "x86_64-linux";
	   specialArgs = { inherit inputs; };
	   modules = [
	    ./hosts/desktop
	    niri.nixosModules.niri
	    home-manager.nixosModules.home-manager
	    {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.layiiesp = import ./home/common.nix;
	      home-manager.extraSpecialArgs = {
		  inherit inputs;
		  isLaptop = false;
	      };
            }
	   ];
	 };
        laptop = nixpkgs.lib.nixosSystem {
           system = "x86_64-linux";
           specialArgs = { inherit inputs; };
           modules = [
            ./hosts/laptop
            niri.nixosModules.niri
            home-manager.nixosModules.home-manager
           {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;
             home-manager.users.layiiesp = import ./home/common.nix;
             home-manager.extraSpecialArgs = {
               inherit inputs;
               isLaptop = true;
 	     };
            }
         ];
       };

        server = nixpkgs.lib.nixosSystem {
           system = "x86_64-linux";
           specialArgs = { inherit inputs; };
           modules = [
            ./hosts/server
            home-manager.nixosModules.home-manager
           {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;
             home-manager.users.layiiesp = import ./home/common.nix;
             home-manager.extraSpecialArgs = {
               inherit inputs;
               isLaptop = false;
             };
            }
         ];
       };

    };
   };
}
