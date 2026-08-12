import kotlinx.serialization.Serializable

@Serializable
data class DemoModel(
    val name: String,
    val timestamp: Long = System.currentTimeMillis()
)
