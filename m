Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FECA3D33E3
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jul 2021 07:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhGWEYv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 23 Jul 2021 00:24:51 -0400
Received: from verein.lst.de ([213.95.11.211]:36903 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhGWEYu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jul 2021 00:24:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 23CA867373; Fri, 23 Jul 2021 07:05:22 +0200 (CEST)
Date:   Fri, 23 Jul 2021 07:05:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210723050521.GA31120@lst.de>
References: <20210722072610.975281-1-hch@lst.de> <20210722072610.975281-2-hch@lst.de> <20210722182254.GB559212@magnolia> <20210722190307.GA14569@lst.de> <20210722190703.GI559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722190703.GI559212@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 12:07:03PM -0700, Darrick J. Wong wrote:
> For this patch (which I guess is now patch 4?) and the original patch 1,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I'll probably make it patch 2 when I resend.  I'll wait a bit for more
comments, though.
