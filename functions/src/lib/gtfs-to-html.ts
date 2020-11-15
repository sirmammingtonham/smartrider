// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'path'.
const path = require('path');

const {
  // @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'clone'.
  clone,
  each,
  map,
  // @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'omit'.
  omit
} = require('lodash');
// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'fs'.
const fs = require('fs-extra');
// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'gtfs'.
const gtfs = require('gtfs');
// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'sanitize'.
const sanitize = require('sanitize-filename');
const Timer = require('timer-machine');

// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'fileUtils'... Remove this comment to see the full error message
const fileUtils = require('./file-utils');
const logUtils = require('./log-utils');
const utils = require('./utils');

/*
 * Generate HTML timetables from GTFS.
 */
module.exports = async (initialConfig: any) => {
  const config = utils.setDefaultConfig(initialConfig);
  config.log = logUtils.log(config);
  config.logWarning = logUtils.logWarning(config);

  await gtfs.openDb(config);

  if (!config.agencies || config.agencies.length === 0) {
    throw new Error('No agencies defined in `config.json`');
  }

  return Promise.all(config.agencies.map(async (agency: any) => {
    const timer = new Timer();
    const agencyKey = agency.agency_key;
    const exportPath = path.join(process.cwd(), 'html', sanitize(agencyKey));
    const outputStats = {
      timetables: 0,
      timetablePages: 0,
      calendars: 0,
      trips: 0,
      routes: 0,
      stops: 0,
      warnings: []
    };

    timer.start();

    if (!config.skipImport) {
      // Import GTFS
      const agencyConfig = clone(omit(config, 'agencies'));
      agencyConfig.agencies = [agency];

      await gtfs.import(agencyConfig);
    }

    const timetablePages = [];
    const timetablePageIds = map(await utils.getTimetablePages(config), 'timetable_page_id');
    await fileUtils.prepDirectory(exportPath);

    const bar = logUtils.progressBar(`${agencyKey}: Generating ${config.outputFormat.toUpperCase()} timetables [:bar] :current/:total `, { total: timetablePageIds.length }, config);

    /* eslint-disable no-await-in-loop */
    for (const timetablePageId of timetablePageIds) {
      const timetablePage = await utils.getFormattedTimetablePage(timetablePageId, config);

      if (timetablePage.consolidatedTimetables.length === 0) {
        const warning = `No timetables found for timetable_page_id=${timetablePage.timetable_page_id}`;
        // @ts-expect-error ts-migrate(2345) FIXME: Argument of type 'string' is not assignable to par... Remove this comment to see the full error message
        outputStats.warnings.push(warning);
        bar.interrupt(logUtils.formatWarning(`${agencyKey}: ${warning}`));
        bar.tick();
        continue;
      }

      for (const timetable of timetablePage.timetables) {
        for (const warning of timetable.warnings) {
          // @ts-expect-error ts-migrate(2345) FIXME: Argument of type 'any' is not assignable to parame... Remove this comment to see the full error message
          outputStats.warnings.push(warning);
          bar.interrupt(logUtils.formatWarning(`${agencyKey}: ${warning}`));
        }
      }

      outputStats.timetables += timetablePage.consolidatedTimetables.length;
      outputStats.timetablePages += 1;

      const datePath = fileUtils.generateFolderName(timetablePage);

      // Make directory if it doesn't exist
      await fs.ensureDir(path.join(exportPath, datePath));
      config.assetPath = '../';

      timetablePage.relativePath = path.join(datePath, sanitize(timetablePage.filename));

      const results = await utils.generateHTML(timetablePage, config);

      each(outputStats, (stat: any, key: any) => {
        if (results.stats[key]) {
          // @ts-expect-error ts-migrate(7053) FIXME: Element implicitly has an 'any' type because expre... Remove this comment to see the full error message
          outputStats[key] += results.stats[key];
        }
      });

      const htmlPath = path.join(exportPath, datePath, sanitize(timetablePage.filename));
      await fs.writeFile(htmlPath, results.html);

      if (config.outputFormat === 'pdf') {
        await fileUtils.renderPdf(htmlPath);
      }

      bar.tick();
      timetablePages.push(timetablePage);
    }
    /* eslint-enable no-await-in-loop */

    // Generate route summary index.html
    config.assetPath = '';
    const html = await utils.generateOverviewHTML(timetablePages, config);
    await fs.writeFile(path.join(exportPath, 'index.html'), html);

    // Generate output log.txt
    const logText = await logUtils.generateLogText(agency, outputStats, config);
    await fs.writeFile(path.join(exportPath, 'log.txt'), logText);

    // Zip output, if specified
    if (config.zipOutput) {
      await fileUtils.zipFolder(exportPath);
    }

    const fullExportPath = path.join(exportPath, config.zipOutput ? '/timetables.zip' : '');

    timer.stop();

    // Print stats
    config.log(`${agencyKey}: ${config.outputFormat.toUpperCase()} timetables created at ${fullExportPath}`);

    logUtils.logStats(outputStats, config);

    const seconds = Math.round(timer.time() / 1000);
    config.log(`${agencyKey}: ${config.outputFormat.toUpperCase()} timetable generation required ${seconds} seconds`);
  }));
};
