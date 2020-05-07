Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6351C8AB4
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 14:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGM1Y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 08:27:24 -0400
Received: from verein.lst.de ([213.95.11.211]:46274 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgEGM1Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 08:27:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D900068B05; Thu,  7 May 2020 14:27:18 +0200 (CEST)
Date:   Thu, 7 May 2020 14:27:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split xfs_iformat_fork
Message-ID: <20200507122718.GA17936@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-4-hch@lst.de> <20200501133431.GJ40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501133431.GJ40250@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 09:34:31AM -0400, Brian Foster wrote:
> > +	default:
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> > +				sizeof(*dip), __this_address);
> > +		return -EFSCORRUPTED;
> > +	}
> 
> Can we fix this function up to use an error variable and return error at
> the end like xfs_iformat_attr_work() does? Otherwise nice cleanup..

What would the benefit of a local variable be here?  It just adds a
little extra code for no real gain.
