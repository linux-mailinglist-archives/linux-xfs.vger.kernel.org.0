Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDD31BADFE
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Apr 2020 21:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgD0Tch (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Apr 2020 15:32:37 -0400
Received: from verein.lst.de ([213.95.11.211]:50795 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgD0Tch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Apr 2020 15:32:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 65CA568C7B; Mon, 27 Apr 2020 21:32:35 +0200 (CEST)
Date:   Mon, 27 Apr 2020 21:32:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxcmd: don't crash if el_gets returns null
Message-ID: <20200427193235.GA24732@lst.de>
References: <20200427170730.GQ6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427170730.GQ6742@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 10:07:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> el_gets returns NULL if it fails to read any characters (due to EOF or
> errors occurred).  strdup will crash if it is fed a NULL string, so
> check the return value to avoid segfaulting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
