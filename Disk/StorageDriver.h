//存储驱动
#include <stdint.h>
#define VIRTIO_BASE      0x10001000UL    //VirtIO设备的 MMIO 起始地址
#define VIRTIO_MAGIC     (*(volatile uint32_t*)(VIRTIO_BASE + 0x000))   //魔数
#define VIRTIO_VERSION   (*(volatile uint32_t*)(VIRTIO_BASE + 0x004))
#define VIRTIO_DEVICE_ID (*(volatile uint32_t*)(VIRTIO_BASE + 0x008))   //设备类型（2 = 块设备，3 = 控制台等）
#define VIRTIO_VENDOR_ID (*(volatile uint32_t*)(VIRTIO_BASE + 0x00C))
#define VIRTIO_STATUS    (*(volatile uint32_t*)(VIRTIO_BASE + 0x070))   //状态寄存器
#define VIRTIO_STATUS_ACKNOWLEDGE 1
#define VIRTIO_STATUS_DRIVER     2
#define VIRTIO_STATUS_DRIVER_OK  4

char initDisk(void);    //初始化
char initDisk(void) {
	//验证魔数
	if (VIRTIO_MAGIC != 0x74726976) return (char)1;
	if (VIRTIO_DEVICE_ID != 2) return (char)1;    //2是块设备
	//通知设备就绪
	VIRTIO_STATUS = VIRTIO_STATUS_ACKNOWLEDGE;
	VIRTIO_STATUS = VIRTIO_STATUS|VIRTIO_STATUS_DRIVER;
    VIRTIO_STATUS = VIRTIO_STATUS|VIRTIO_STATUS_DRIVER_OK;
    return (char)0;
}