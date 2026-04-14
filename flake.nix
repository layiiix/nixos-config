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
   };
	
    outputs = { self, nixpkgs, home-manager, noctalia, niri, ... }@inputs: {
      nixosConfigurations = {
         desktop = nixpkgs.lib.nixosSystem {
           system = "x86_64-linux";
	   specialArgs = { inherit inputs; };
	   modules = [
	    ./hosts/desktop
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
             home-manager.users.laylisp = import ./home/common.nix;
             home-manager.extraSpecialArgs = {
               inherit inputs;
               isLaptop = true;
 	     };
            }
         ];
       };

    };
   };
}
