<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('solicitudes_cambio', function (Blueprint $table) {
            // Campos de auditoría para aprobación
            $table->char('aprobado_por', 36)->nullable()->after('resumen_impacto');
            $table->timestamp('aprobado_en')->nullable()->after('aprobado_por');
            
            // Campos de auditoría para rechazo  
            $table->char('rechazado_por', 36)->nullable()->after('aprobado_en');
            $table->timestamp('rechazado_en')->nullable()->after('rechazado_por');
            $table->text('motivo_rechazo')->nullable()->after('rechazado_en');
            
            // Relaciones de foreign keys
            $table->foreign('aprobado_por')->references('id')->on('usuarios');
            $table->foreign('rechazado_por')->references('id')->on('usuarios');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('solicitudes_cambio', function (Blueprint $table) {
            $table->dropForeign(['aprobado_por']);
            $table->dropForeign(['rechazado_por']);
            $table->dropColumn([
                'aprobado_por',
                'aprobado_en', 
                'rechazado_por',
                'rechazado_en',
                'motivo_rechazo'
            ]);
        });
    }
};
