Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6C27E0099
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Nov 2023 11:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbjKCIOM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Nov 2023 04:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbjKCIOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2023 04:14:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05EA1B9;
        Fri,  3 Nov 2023 01:14:08 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 15F8B68AA6; Fri,  3 Nov 2023 09:14:06 +0100 (CET)
Date:   Fri, 3 Nov 2023 09:14:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Chandan Babu R <chandanbabu@kernel.org>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <djwong@kernel.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        dchinner@fromorbit.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [BUG REPORT] next-20231102: generic/311 fails on XFS with
 external log
Message-ID: <20231103081405.GC16854@lst.de>
References: <87bkccnwxc.fsf@debian-BULLSEYE-live-builder-AMD64> <20231102-teich-absender-47a27e86e78f@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102-teich-absender-47a27e86e78f@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2023 at 03:54:48PM +0100, Christian Brauner wrote:
> So you'll see EBUSY because the superblock was already frozen when the
> main block device was frozen. I was somewhat expecting that we may run
> into such issues.
> 
> I think we just need to figure out what we want to do in cases the
> superblock is frozen via multiple devices. It would probably be correct
> to keep it frozen as long as any of the devices is frozen?

As dave pointed out I think we need to bring back / keep the freeze
count.
