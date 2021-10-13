Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C581E42C77E
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Oct 2021 19:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJMRXW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Oct 2021 13:23:22 -0400
Received: from mail.itouring.de ([85.10.202.141]:46066 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhJMRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 13:23:22 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2021 13:23:22 EDT
Received: from tux.applied-asynchrony.com (p5ddd741d.dip0.t-ipconnect.de [93.221.116.29])
        by mail.itouring.de (Postfix) with ESMTPSA id 14CACD2992A
        for <linux-xfs@vger.kernel.org>; Wed, 13 Oct 2021 19:13:11 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id B0993F01604
        for <linux-xfs@vger.kernel.org>; Wed, 13 Oct 2021 19:13:10 +0200 (CEST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Sorting blocks in xfs_buf_delwri_submit_buffers() still necessary?
Organization: Applied Asynchrony, Inc.
Message-ID: <05c69404-cc05-444b-e4b0-1e358deae272@applied-asynchrony.com>
Date:   Wed, 13 Oct 2021 19:13:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Based on what's going on in blk-mq & NVMe land I though I'd check if XFS still
sorts buffers before sending them down the pipe, and sure enough that still
happens in xfs_buf.c:xfs_buf_delwri_submit_buffers() (the comparson function
is directly above). Before I make a fool of myself and try to remove this,
do we still think this is necessary? If there's a scheduler it will do the
same thing, and SSD/NVMe might do the same in HW anyway or not care.
The only scenario I can think of where this might make a difference is
rotational RAID without scheduler attached. Not sure.

I'm looking forward to hear what a foolish idea this is.

cheers
Holger
