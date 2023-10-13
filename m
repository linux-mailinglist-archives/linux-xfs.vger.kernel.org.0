Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6E7C7D40
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Oct 2023 07:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjJMFx3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Oct 2023 01:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJMFx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 01:53:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E4DB8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 22:53:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7827D67373; Fri, 13 Oct 2023 07:53:25 +0200 (CEST)
Date:   Fri, 13 Oct 2023 07:53:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK
 macros
Message-ID: <20231013055324.GA6991@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721662.1773834.1354453014423462886.stgit@frogsfrogsfrogs> <20231012053306.GA2795@lst.de> <20231012182030.GL21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012182030.GL21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 11:20:30AM -0700, Darrick J. Wong wrote:
> > Random rambling: there is a fairly large chunk of code duplicated
> > here.  Maybe the caching series and/or Dave's suggest args cleanup
> > would be good opportunity to refactor it.  Same for the next two
> > clusters of two chunks.
> 
> Yeah, Dave and I will have to figure out how to integrate these two.
> I might just pull in his rtalloc_args patch at the end of this series.

They way I understood his review of Omars patches isn't that he
has a rtalloc_args patch, but suggest adding that structure.

I can take care of that after your series and Omar has landed, together
with the bitmap/summary access abstraction.
