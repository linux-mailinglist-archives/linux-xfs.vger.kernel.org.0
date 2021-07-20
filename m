Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E093CF490
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jul 2021 08:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhGTFxP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Jul 2021 01:53:15 -0400
Received: from verein.lst.de ([213.95.11.211]:53895 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhGTFxM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jul 2021 01:53:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C7DD768AFE; Tue, 20 Jul 2021 08:33:49 +0200 (CEST)
Date:   Tue, 20 Jul 2021 08:33:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210720063349.GA14747@lst.de>
References: <20210712111426.83004-1-hch@lst.de> <20210712111426.83004-2-hch@lst.de> <20210714111049.dxhrtupk46ls4ujb@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714111049.dxhrtupk46ls4ujb@omega.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:10:49PM +0200, Carlos Maiolino wrote:
> > -	mutex_unlock(&q->qi_quotaofflock);
> > -	return error;
> > +	/* XXX what to do if error ? Revert back to old vals incore ? */
>
> May be too strict, but I wonder if we shouldn't shut the FS down in case we fail
> here?

This is just the existing code being unindented by one level.  The
usual transaction commit failure cases will cause a shutdown anyway.
