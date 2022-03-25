const appName = 'Fun Ideas';

enum bioLockOptions {
  noHardware, hasHardware
}

enum setupStages {
  nameStage,bioLockStage
}

enum httpRequestStages {
  fetching, fetched, error
}

const activityApi = 'https://www.boredapi.com/api/activity/';