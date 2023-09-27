Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9E17AF90C
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Sep 2023 06:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjI0ELB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Sep 2023 00:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjI0EJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2023 00:09:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434B81C26F
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 20:49:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E9BC433C7;
        Wed, 27 Sep 2023 03:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695786595;
        bh=1UpLYh6hDdVRK+mjMQo1IQLJJP9Q7rjNy/O33J/F9Pg=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=iuBTE5pCXvijzzJ5tEZa+DHMvsXXFvyKXb42HSXqy2XaSJ7j2QPtsHE16OdAYsQ9A
         US0PMIsi+bGROElp3FzwaDQPWsw7g53P7ghk6mJigk1edzr4KgpxE3a4QrO2qhrMyN
         UnqTVdpE5i+S3W9DieJsYvgBU+9vAd/Df8a6j79MVkcEqqPppD6HqCrRdSSj5KuMKw
         +FmVVKqrI/Ug7xgsJXXs2Jx1zv41JXNU0KoADfUHdwPRcCF7cWQQXHxaqbPjLZkK29
         Xwo6MK0njKT/Itvcdx20BPiz2urpUq8CvI70+szf/LaXatRFTzd3DHkv9CUgGZW3Pm
         05mGhFyNpUGBQ==
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Date:   Wed, 27 Sep 2023 09:08:41 +0530
In-reply-to: <20230927014632.GE11456@frogsfrogsfrogs>
Message-ID: <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 06:46:32 PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
>> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
>> > On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
>> > > Hi,
>> > > 
>> > > Any comments?
>> > 
>> > I notice that xfs/55[0-2] still fail on my fakepmem machine:
>> > 
>> > --- /tmp/fstests/tests/xfs/550.out	2023-09-23 09:40:47.839521305 -0700
>> > +++ /var/tmp/fstests/xfs/550.out.bad	2023-09-24 20:00:23.400000000 -0700
>> > @@ -3,7 +3,6 @@ Format and mount
>> >  Create the original files
>> >  Inject memory failure (1 page)
>> >  Inject poison...
>> > -Process is killed by signal: 7
>> >  Inject memory failure (2 pages)
>> >  Inject poison...
>> > -Process is killed by signal: 7
>> > +Memory failure didn't kill the process
>> > 
>> > (yes, rmap is enabled)
>> 
>> Yes, I see the same failures, too. I've just been ignoring them
>> because I thought that all the memory failure code was still not
>> complete....
>
> Oh, I bet we were supposed to have merged this
>
> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/
>
> to complete the pmem media failure handling code.  Should we (by which I
> mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?
>

I can add this patch into XFS tree for 6.7. But I will need Acks from Andrew
Morton and Dan Williams.

-- 
Chandan
