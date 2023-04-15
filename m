Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F16E2DED
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Apr 2023 02:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjDOA2j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Apr 2023 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjDOA2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 20:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B255C728A;
        Fri, 14 Apr 2023 17:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B08164546;
        Sat, 15 Apr 2023 00:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B7AC433EF;
        Sat, 15 Apr 2023 00:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681518512;
        bh=CNCHQhZHR7YLwN8+727t5jjCnolSaO0tbAFvdHtH5tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bJYQXbzI6FerVvG0ZZZqyzEasGg/+jdxan3SUkBpBSLjdPyYdhDml4Q9k4D+p7EJ1
         OAqCqNXSsl5EZTi8d2d+K5FlFSXNg39OIjjPK+oB97BbxfG4cyRz/k2/lY84+KbTER
         /fknnaV7OwvYoFkKok4TuKogl+4VeweRMhDbjU0RKoW1zbeRUQpmqkyI4evGaiA7xZ
         atRqetccJksPrAOf1BX4miCheNnvwwVnWX/f6p3+WIkZhDUBbDVef3Gjehf2DkRPWS
         DzLFsH9pnDmbNR6Zm+cGdbmLXgiQUZxI0fOatCJE7/u/bLPgzROwSqepwzlkJxQHIh
         Wt3+4k6Sjcdqw==
Date:   Fri, 14 Apr 2023 17:28:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET 0/3] fstests: direct specification of looping test
 duration
Message-ID: <20230415002832.GY360889@frogsfrogsfrogs>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
 <20230413104836.zw2uoe4mhocs3afz@aalbersh.remote.csb>
 <20230413144708.GL360895@frogsfrogsfrogs>
 <20230413154352.v55cc3tfhezxlw5s@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413154352.v55cc3tfhezxlw5s@aalbersh.remote.csb>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 05:43:52PM +0200, Andrey Albershteyn wrote:
> On Thu, Apr 13, 2023 at 07:47:08AM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 13, 2023 at 12:48:36PM +0200, Andrey Albershteyn wrote:
> > > >  tests/generic/648     |    8 +++--
> > > >  17 files changed, 229 insertions(+), 13 deletions(-)
> > > >  create mode 100644 src/soak_duration.awk
> > > > 
> > > 
> > > The set looks good to me (the second commit has different var name,
> > > but fine by me)
> > 
> > Which variable name, specifically?
> 
> STRESS_DURATION in the commit message

Ah, will fix and resend.  Thanks for noticing!

--D

> -- 
> - Andrey
> 
