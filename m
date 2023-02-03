Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903C36898F2
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Feb 2023 13:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjBCMit (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Feb 2023 07:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBCMis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2023 07:38:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4340A9AFE5
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 04:38:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2A5361F19
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 12:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E44C433D2;
        Fri,  3 Feb 2023 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675427927;
        bh=bV2A7e3MoJZkbH3BThlALrK6HwGFKBwW9jELmjAqqSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sgcGZMbx7daSWJBw0itK266fNo+evP4AcC1YEWkxQwtRsZFtMhLq+Jgq0uaAlmaTC
         R62pVTmyVksN9Ouf9wb8mQh+4EkzeGqbJyWFs2VCiIJxdpyAIfwGv9A64+vkEs8jeO
         ib3zxn7wOxFb+lGhhKvY4VplrshXxhaPbqAxxwJ+OKSnFp8XrwxHZ2IGWGiDFxubn7
         dYuDFd6M9mGxM1ZQXmQJbI8TbFyWeYtobHuEkyKpi6mYHLZCmhgExgWUBbJnK8Kiec
         lQ5qDZ8bcMTW4IMg0t/g+EVX41+qgxnUqHZt572H+VlR4bg9Ss84phmpG8Wk/ZPrNy
         8BO4DE0RD3BeQ==
Date:   Fri, 3 Feb 2023 13:38:43 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Panagiotis Papadakos <papadako@ics.forth.gr>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs_repair: fatal error -- couldn't map inode 13199169, err = 117
Message-ID: <20230203123843.oq2nobgyoxau67b5@andromeda>
References: <EHyZekx1O-pqePkGfRDKAjIdo4T1Oc5ZgucxgVcs4zwc5d7uPmA6F9sPBM9gjh7xw8hXbfVfy_kg7NtvmvBU8A==@protonmail.internalid>
 <86696f1f1b39a175e99f43128f09a722@mailhost.ics.forth.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86696f1f1b39a175e99f43128f09a722@mailhost.ics.forth.gr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 02:55:12PM +0200, Panagiotis Papadakos wrote:
> Dear all,
> 
> I am using XFS on an ICY-BOX 4-bay USB RAID enclosure which
> unfortunately has been corrupted (probably due to some power-down).

XFS filesystem shouldn't be corrupted due to a power failure at the first place,
that's the main reason behind journaling filesystems.

> 
> I have used xfs_repair -L,


This is what I'd expect after a power failure, a dirty log which should be
replayed *before* attempting to repair the filesystem, why did you discard
the journal? Have you tried to mount/umount the filesystem before running
xfs_repair -L?

> which after a huge number of messages about
> free inode references, bad hash tables, etc, fails with the following
> error:
> 
> fatal error -- couldn't map inode 13199169, err = 117

Always send the full output :)

> Is there anything I can do or should I consider my data lost?

The fact you discarded the journal in the first place, you've already lost some
data, how much, depends on how much information was in the journal waiting to be
replayed :(

-- 
Carlos Maiolino
