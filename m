Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6640E7D1EC3
	for <lists+linux-xfs@lfdr.de>; Sat, 21 Oct 2023 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjJUR5J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 21 Oct 2023 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjJUR5I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Oct 2023 13:57:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0134BD41
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2023 10:57:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD99DC433C8;
        Sat, 21 Oct 2023 17:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697911026;
        bh=pFrOkwxTre0sOV+Eoz+9LtgVNs6Suir0YHRmZXpiw8E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gC4Z2N5DQZLNcvgn+TCi+7wVHnaVWKWlLKMxG0g4VZEbbbHLirdU8hMJ3t/Mvvl9q
         PQL7prRbT+tgFzYCMcR0qqv6+yg6X3pFy18X30ochMAsfZ9lFjMbuxLDVkxUtRGkaK
         3j8IENdoKZWihRLSdCv2V31dkaQD8Ca+LPz8JjtQwUxSAM96JQ8wAZ355NfrOiYWUx
         2fIeug+n5TRe4mo7N3wnMdDWLaTSck6b8I90Hm89t8rQnm+wBYHyE+o8Eap9W7QnKI
         bGaMJxTa+NrdhJipix9ybcrg41uqwxUJUr+grltcIvjneM4B8MaLv64Uxy5XWgGPNo
         jXcAN83MKbHag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFE7EC04DD9;
        Sat, 21 Oct 2023 17:57:06 +0000 (UTC)
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5
X-PR-Tracked-Commit-Id: 3ac974796e5d94509b85a403449132ea660127c2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5722119f674d81eb88d51463ece8096855d94cc0
Message-Id: <169791102670.24251.2347842521338954833.pr-tracker-bot@kernel.org>
Date:   Sat, 21 Oct 2023 17:57:06 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org, hch@lst.de,
        jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 20 Oct 2023 23:27:44 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5722119f674d81eb88d51463ece8096855d94cc0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
