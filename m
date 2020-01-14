Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B7F13ADF0
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2020 16:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgANPpm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jan 2020 10:45:42 -0500
Received: from verein.lst.de ([213.95.11.211]:46578 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbgANPpm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Jan 2020 10:45:42 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8548668AFE; Tue, 14 Jan 2020 16:45:40 +0100 (CET)
Date:   Tue, 14 Jan 2020 16:45:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     hch@lst.de, darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Add __packed to xfs_dir2_sf_entry_t definition
Message-ID: <20200114154540.GA7194@lst.de>
References: <20200114120352.53111-1-vincenzo.frascino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114120352.53111-1-vincenzo.frascino@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
