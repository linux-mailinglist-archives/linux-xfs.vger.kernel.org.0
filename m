Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1A104C4B
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Nov 2019 08:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKUHU3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Nov 2019 02:20:29 -0500
Received: from verein.lst.de ([213.95.11.211]:44353 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUHU3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Nov 2019 02:20:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4355468B05; Thu, 21 Nov 2019 08:20:27 +0100 (CET)
Date:   Thu, 21 Nov 2019 08:20:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling
 conventions
Message-ID: <20191121072027.GA23961@lst.de>
References: <20191120111727.16119-1-hch@lst.de> <20191120111727.16119-4-hch@lst.de> <20191120181708.GM6219@magnolia> <20191120182035.GA11912@lst.de> <20191121054458.GX6219@magnolia> <20191121060627.GA22808@lst.de> <20191121071530.GY6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121071530.GY6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:15:30PM -0800, Darrick J. Wong wrote:
> Here's what I've been testing with, though FWIW I'm about to go to bed
> so you might as well keep going, particularly if you see anything funny
> here.

This looks the same as the version I have.  It creates a trivial
conflict with one of the later patches that I've also fixed up.
