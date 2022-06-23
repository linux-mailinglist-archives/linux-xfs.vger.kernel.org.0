Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148255570D1
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Jun 2022 04:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355512AbiFWCBs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Jun 2022 22:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiFWCBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 22:01:48 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EF71D7F
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 19:01:47 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 482745196E5
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 21:00:56 -0500 (CDT)
Message-ID: <bada3305-3019-df58-cc6f-d7abc08bbdee@sandeen.net>
Date:   Wed, 22 Jun 2022 21:01:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [ANNOUNCE] xfsprogs updated to 5.19.0-rc0
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
References: <3efbe2a8-5f82-896e-e316-e8075dd88c5c@sandeen.net>
In-Reply-To: <3efbe2a8-5f82-896e-e316-e8075dd88c5c@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/22/22 8:56 PM, Eric Sandeen wrote:
> Hi folks,
> 
> The for-next branch of the xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> This is just the 5.19 libxfs sync, plus a small handful of tool updates
> to allow mkfs w/ new on disk features, reporting in xfs_info, logprint,
> etc.

Big thanks to Chandan and Dave for doing most of the work to get the sync
in order.

-Eric
