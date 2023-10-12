Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33317C643C
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 06:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347036AbjJLEwh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 00:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343533AbjJLEwh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 00:52:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207C190
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 21:52:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 93D786732D; Thu, 12 Oct 2023 06:52:31 +0200 (CEST)
Date:   Thu, 12 Oct 2023 06:52:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 3/3] xfs: rt stubs should return negative errnos when
 rt disabled
Message-ID: <20231012045231.GC1637@lst.de>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs> <169704720379.1773263.4032428007620392316.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720379.1773263.4032428007620392316.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:02:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When realtime support is not compiled into the kernel, these functions
> should return negative errnos, not positive errnos.  While we're at it,
> fix a broken macro declaration.

I would love to eventually see these as inline functions to also improve
error checking.  I'm not going to burden that on you now, though.

Reviewed-by: Christoph Hellwig <hch@lst.de>

